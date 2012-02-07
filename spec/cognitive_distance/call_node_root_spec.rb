require File.expand_path('../../spec_helper', __FILE__)

describe CognitiveDistance::CallNodeRoot do
  before do
    @node = CognitiveDistance::CallNodeRoot.new
  end

  it "should always return itself on pop!" do
    @node.pop!.must_equal @node
  end

  it "should not have a context" do
    @node.context.is_a?(CognitiveDistance::MissingCallContext).must_equal true
  end

  it "should not yield itself when enumerating" do
    @node.inject(false) { |found, n|
      found || n.equal?(@node)
    }.must_equal false
  end
end

