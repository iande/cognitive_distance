require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Presenters::GraphToDot do
  before do
    @presenter = CognitiveDistance::Presenters::GraphToDot.new
    @graph = CognitiveDistance::Structures::Graph.new
    @graph.link :a, :b, :c
    @graph.link :b, :c
  end

  it "converts a graph to dot format" do
    dotted = @presenter.present @graph
    dotted.must_match /^digraph "graphname"/
    dotted.must_match /"a" -> "b";/
    dotted.must_match /"a" -> "c";/
    dotted.must_match /"b" -> "c";/
  end

  it "names the graph" do
    dotted = @presenter.present @graph, "My Graph"
    dotted.must_match /^digraph "My Graph"/
    dotted.must_match /"a" -> "b";/
    dotted.must_match /"a" -> "c";/
    dotted.must_match /"b" -> "c";/
  end

  it "uses a block to map nodes to names" do
    dotted = @presenter.present(@graph, "Blocked!") { |v| "Node #{v}" }
    dotted.must_match /^digraph "Blocked!"/
    dotted.must_match /"Node a" -> "Node b";/
    dotted.must_match /"Node a" -> "Node c";/
    dotted.must_match /"Node b" -> "Node c";/
  end
end

