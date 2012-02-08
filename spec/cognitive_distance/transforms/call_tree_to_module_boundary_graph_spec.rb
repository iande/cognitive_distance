require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph do
  # What is a module boundary graph?
  # It should be a graph (duh) where nodes represent
  # modules/classes and the edges indicate
  # a call that crossed that boundary. Edges can be weighted, indicating the
  # number of times that boundary was crossed.
  # We've got the nodes (CallNode), so we need a representation for a weighted
  # edge, and a collection to hold them
  before do
    @transformer = CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph.new
    # And this is why I'm a little hesitant to mock out CallTrees
    @nodes = make_tree_nodes([
      [:n1, :c1, [
        [ :n1_1, :c3, [] ],         # change n_1 => n_1_1
        [ :n1_2, :c1, [
          [ :n1_2_1, :c1, [
            [ :n1_2_1_1, :c4, [] ]  # change n1_2_1 => n1_2_1_1
          ] ]
        ] ]
      ] ],
      [:n2, :c2, [
        [ :n2_1, :c2, [
          [ :n2_1_1, :c1, [] ]      # change n2_1 => n2_1_1
        ] ],
        [ :n2_2, :c1, [] ]          # change n2 => n2_2
      ] ]
    ])
    @tree = MiniTest::Mock.new
    @tree.expect :to_a, @nodes
  end

  class MockNode
    attr_reader :context, :children
    alias :ch :children
    def initialize arr
      @name = arr[0]
      @context = arr[1]
      @children = arr[2].map { |cs| MockNode.new(cs) }
    end
  end

  def make_tree_nodes arr
    arr.map { |ns| MockNode.new(ns) }
  end

  it "transforms a CallTree into a graph of boundary crossings" do
    graph = @transformer.transform(@tree)
    graph.vertices.size.must_equal 8
    graph.edges.size.must_equal 4
    graph.must_equal [
      [ @nodes[0], @nodes[0].ch[0] ],
      [ @nodes[1], @nodes[1].ch[1] ],
      [ @nodes[0].ch[1].ch[0], @nodes[0].ch[1].ch[0].ch[0] ],
      [ @nodes[1].ch[0], @nodes[1].ch[0].ch[0] ]
    ]
  end

  it "provides a singleton convenience method" do
    graph1 = @transformer.transform(@tree)
    graph2 = CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph.transform(@tree)
    graph1.must_equal graph2
  end
end

