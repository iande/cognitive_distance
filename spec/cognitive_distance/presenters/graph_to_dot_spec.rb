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
    dotted.must_equal "digraph \"graphname\" {\n\"a\" -> \"b\";\n\"a\" -> \"c\";\n\"b\" -> \"c\";\n}"
  end

  it "names the graph" do
    dotted = @presenter.present @graph, "MyGraph"
    dotted.must_equal "digraph \"MyGraph\" {\n\"a\" -> \"b\";\n\"a\" -> \"c\";\n\"b\" -> \"c\";\n}"
  end

  it "uses a block to map nodes to names" do
    dotted = @presenter.present(@graph, "Blocked!") { |v| "Node #{v}" }
    dotted.must_equal "digraph \"Blocked!\" {\n\"Node a\" -> \"Node b\";\n\"Node a\" -> \"Node c\";\n\"Node b\" -> \"Node c\";\n}"
  end
end

