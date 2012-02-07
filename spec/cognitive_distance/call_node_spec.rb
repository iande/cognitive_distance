require File.expand_path('../../spec_helper', __FILE__)

describe CognitiveDistance::CallNode do
  before do
    @parent = Object.new
    @node = CognitiveDistance::CallNode.new(@parent)
  end

  it "sets a parent" do
    @node.parent.must_equal @parent
  end

  it "returns its parent on pop!" do
    @node.pop!.must_equal @parent
  end

  it "returns a newly created child on push!" do
    child = @node.push! 1, 2, 3, 4, 5
    @node.children.last.must_equal child
  end

  it "completely sets up the new child" do
    child = @node.push! 1, 2, 3, 4, 5
    child.trace_class.must_equal 1
    child.trace_method.must_equal 2
    child.trace_file.must_equal 3
    child.trace_line.must_equal 4
    child.trace_binding.must_equal 5
    child.parent.must_equal @node
    child.children.must_be_empty
  end

  it "generates a context from a binding" do
    method = [].method(:empty?)
    binding = method.to_proc.binding
    @node.trace_binding = binding
    @node.context.must_equal method
  end

  it "yields itself and then each child when enumerating" do
    # Make a child
    @node.trace_class = 0
    child1 = @node.push!(1, nil, nil, nil, nil)
    # And two grandchildren
    child1.push!(11, nil, nil, nil, nil)
    child1.push!(12, nil, nil, nil, nil)
    # Make another child
    @node.push!(2, nil, nil, nil, nil)
    @node.map(&:trace_class).must_equal [0, 1, 11, 12, 2]
  end

  it "is empty when it has no children" do
    @node.empty?.must_equal true
    @node.push! 1, nil, nil, nil, nil
    @node.empty?.must_equal false
  end

  it "determines size by the number of children plus their sizes" do
    child1 = @node.push! nil, nil, nil, nil, nil
    child2 = @node.push! nil, nil, nil, nil, nil
    child1.push! nil, nil, nil, nil, nil
    child1.push! nil, nil, nil, nil, nil
    child2.push! nil, nil, nil, nil, nil
    # node => 2 children, child1 => 2 children, child2 => 1 child
    @node.size.must_equal 5
  end

  it "freezes its children when freezing" do
    child1 = @node.push! nil, nil, nil, nil, nil
    child1.push! nil, nil, nil, nil, nil
    @node.freeze
    @node.all?(&:frozen?).must_equal true
    @node.children.frozen?.must_equal true
  end
end

