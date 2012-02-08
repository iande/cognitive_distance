require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Structures::Graph do
  before do
    @graph = CognitiveDistance::Structures::Graph.new
  end

  class TestSubGraph < CognitiveDistance::Structures::Graph
  end

  it "is empty when there is nothing in it" do
    @graph.empty?.must_equal true
    @graph.link "vertex 1", "vertex 2"
    @graph.empty?.must_equal false
  end

  it "records vertices" do
    @graph.vertices.size.must_equal 0
    @graph.link "vertex 1", "vertex 2", "vertex 3", "vertex 4", "vertex 2"
    @graph.link "vertex 2", "vertex 3", "vertex 5", "vertex 1"
    @graph.vertices.size.must_equal 5
  end

  it "records edges" do
    @graph.edges.size.must_equal 0
    @graph.link "vertex 1", "vertex 2", "vertex 3", "vertex 4", "vertex 2"
    @graph.link "vertex 2", "vertex 3", "vertex 5", "vertex 1"
    @graph.edges.size.must_equal 7
  end

  it "is enumerable" do
    @graph.class.must_include Enumerable
  end

  it "enumerates over edges" do
    collected = @graph.map { |e| e }
    collected.must_equal @graph.edges
  end

  it "returns vertices that share an edge with the given vertex" do
    @graph.link "vertex 1", "vertex 2", "vertex 3"
    @graph.any_edges("vertex 4").size.must_equal 0
    @graph.link "vertex 1", "vertex 4"
    @graph.link "vertex 4", "vertex 2"
    edges = @graph.any_edges("vertex 4")
    edges.size.must_equal 2
    edges.must_include ["vertex 1", "vertex 4"]
    edges.must_include ["vertex 4", "vertex 2"]
   end

  it "returns vertices that link out of the given vertex" do
    @graph.link "vertex 1", "vertex 2", "vertex 4"
    @graph.out_edges("vertex 4").size.must_equal 0
    @graph.link "vertex 4", "vertex 2"
    edges = @graph.out_edges("vertex 4")
    edges.must_equal [ [ "vertex 4", "vertex 2" ] ]
  end

  it "returns vertices link into the given vertex" do
    @graph.link "vertex 4", "vertex 2", "vertex 3"
    @graph.in_edges("vertex 4").size.must_equal 0
    @graph.link "vertex 1", "vertex 4"
    edges = @graph.in_edges("vertex 4")
    edges.must_equal [ [ "vertex 1", "vertex 4" ] ]
  end

  it "records bi-directional links" do
    @graph.bilink "vertex 1", "vertex 2"
    @graph.in_edges("vertex 1").must_equal [ ["vertex 2", "vertex 1"] ]
    @graph.out_edges("vertex 1").must_equal [ ["vertex 1", "vertex 2"] ]
    @graph.in_edges("vertex 2").must_equal [ ["vertex 1", "vertex 2"] ]
    @graph.out_edges("vertex 2").must_equal [ ["vertex 2", "vertex 1"] ]
  end

  it "converts to an array of edges" do
    @graph.bilink "vertex 1", "vertex 2"
    @graph.link "vertex 1", "vertex 4"
    edge_array = @graph.to_a
    edge_array.size.must_equal 3
    edge_array.must_include ["vertex 1", "vertex 2"]
    edge_array.must_include ["vertex 2", "vertex 1"]
    edge_array.must_include ["vertex 1", "vertex 4"]
  end

  it "is always equal to itself" do
    (@graph == @graph).must_equal true
    @graph.link "a", "b"
    (@graph == @graph).must_equal true
  end

  it "is equal (==) to another graph iff they have the same edges" do
    graph2 = CognitiveDistance::Structures::Graph.new
    @graph.bilink "vertex 1", "vertex 2"
    @graph.link "vertex 3", "vertex 1"
    @graph.link "vertex 2", "vertex 4"

    graph2.link "vertex 1", "vertex 2"
    graph2.link "vertex 2", "vertex 4"
    graph2.link "vertex 3", "vertex 1"
   
    (graph2 == @graph).must_equal false
    (@graph == graph2).must_equal false
    graph2.link "vertex 2", "vertex 1"
    (graph2 == @graph).must_equal true
    (@graph == graph2).must_equal true
  end

  it "is equal (==) to an array of edges" do
    @graph.bilink "vertex 1", "vertex 2"
    @graph.link "vertex 3", "vertex 1"
    @graph.link "vertex 2", "vertex 4"
    (@graph == [
      [ "vertex 1", "vertex 2" ],
      [ "vertex 2", "vertex 4" ],
      [ "vertex 3", "vertex 1" ],
      [ "vertex 2", "vertex 1" ]
    ]).must_equal true
  end

  it "is only identical (equal?) to itself" do
    graph2 = CognitiveDistance::Structures::Graph.new
    @graph.link "a", "b"
    graph2.link "a", "b"
    (@graph == graph2).must_equal true
    @graph.equal?(graph2).must_equal false
    graph2.equal?(@graph).must_equal false
    @graph.equal?(@graph).must_equal true
    graph2.equal?(graph2).must_equal true
  end

  it "is type equal (eql?) to another graph iff they have the same edges" do
    graph2 = TestSubGraph.new
    graph3 = [ [ "a", "b" ] ]
    @graph.link "a", "b"
    graph2.link "a", "b"
    @graph.eql?(graph2).must_equal true
    graph2.eql?(@graph).must_equal true
    @graph.eql?(graph3).must_equal false
    graph2.eql?(graph3).must_equal false
  end
end

