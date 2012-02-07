require File.expand_path('../../spec_helper', __FILE__)

describe CognitiveDistance::CallTree do
  before do
    @call_tree = CognitiveDistance::CallTree.new
  end

  def populate_tree
    @call_tree.called 1, nil, nil, nil, nil
    @call_tree.called 11, nil, nil, nil, nil
    @call_tree.returned 11, nil, nil, nil, nil
    @call_tree.called 12, nil, nil, nil, nil
    @call_tree.returned 12, nil, nil, nil, nil
    @call_tree.returned 1, nil, nil, nil, nil
    @call_tree.called 2, nil, nil, nil, nil
    @call_tree.called 21, nil, nil, nil, nil
    @call_tree.returned 21, nil, nil, nil, nil
    @call_tree.returned 2, nil, nil, nil, nil
    @call_tree.called 3, nil, nil, nil, nil
    @call_tree.returned 3, nil, nil, nil, nil
  end

  it "is empty when there's nothing in the tree" do
    @call_tree.empty?.must_equal true
    @call_tree.called nil, nil, nil, nil, nil
    @call_tree.empty?.must_equal false
  end

  it "only contains top level children when converted to an array" do
    populate_tree
    @call_tree.to_a.map(&:trace_class).must_equal [1, 2, 3]
  end

  it "contains all nodes when enumerated" do
    populate_tree
    @call_tree.map(&:trace_class).must_equal [1, 11, 12, 2, 21, 3]
  end

  it "calculates size from the children of the root" do
    populate_tree
    @call_tree.size.must_equal 6
  end

  it "freezes all nodes when freezing the tree" do
    populate_tree
    @call_tree.freeze
    @call_tree.all?(&:frozen?).must_equal true
  end
end

