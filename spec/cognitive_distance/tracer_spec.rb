require File.expand_path('../../spec_helper', __FILE__)

describe CognitiveDistance::Tracer do
  before do
    @traced_obj = CognitiveDistance::Test::TracesInternal.new
    @tracer = CognitiveDistance::Tracer.new(@traced_obj)
  end

  def to_nested_array tree
    nested_node_array(tree.to_a.first)
  end

  def nested_node_array node
    arr = []
    children = node.children.map { |c| to_nested_array(c) }
    arr << node.trace_method
    arr + children
  end

  it "returns a CallTree after tracing" do
    call_tree = @tracer.trace(:method1)
    call_tree.is_a?(CognitiveDistance::CallTree).must_equal true
    call_tree.to_a.size.must_equal 1
  end

  it "traces out a CallTree" do
    call_tree = @tracer.trace(:method1)
    to_nested_array(call_tree).must_equal [ :method1,
                                              [:method2, [:method4]],
                                              [:method3] ]
  end
end

