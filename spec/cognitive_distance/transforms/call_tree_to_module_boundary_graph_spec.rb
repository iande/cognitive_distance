require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph do
  def make_binding
    [].method(:length).to_proc.binding
  end

  def make_tree
    b1, b2, b3, b4 = 4.times.map { make_binding }
    nils = [nil, nil, nil]
    CognitiveDistance::Structures::CallTree.new.tap do |tree|
      tree.called 1, *nils, b1
      tree.called 2, *nils, b3
      tree.returned 2, *nils, b3 # => 1
      tree.called 3, *nils, b1
      tree.called 4, *nils, b1
      tree.called 5, *nils, b4
      tree.returned 5, *nils, b4 # => 4
      tree.returned 4, *nils, b1 # => 3
      tree.returned 3, *nils, b1 # => 1
      tree.returned 1, *nils, b1 # => ROOT

      tree.called 20, *nils, b2
      tree.called 21, *nils, b2
      tree.called 22, *nils, b1
      tree.returned 22, *nils, b1 # => 21
      tree.returned 21, *nils, b2 # => 20
      tree.called 23, *nils, b1
      tree.returned 23, *nils, b1 # => 20
      tree.returned 20, *nils, b2 # => ROOT
    end
  end

  before do
    @transformer = CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph.new
    # We're specifically transforming a call tree, so let's use a real one
    @tree = make_tree
  end

  it "transforms a CallTree into a graph of boundary crossings" do
    graph = @transformer.transform(@tree)
    graph.vertices.size.must_equal 8
    graph.edges.size.must_equal 4
    mapped = graph.map { |(v1,v2)| [v1.trace_class, v2.trace_class] }
    mapped.must_include [1, 2]
    mapped.must_include [4, 5]
    mapped.must_include [20, 23]
    mapped.must_include [21, 22]
  end

  it "provides a singleton convenience method" do
    graph1 = @transformer.transform(@tree)
    graph2 = CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph.transform(@tree)
    graph1.must_equal graph2
  end
end

