require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Structures::CallNodeRoot do
  before do
    @node = CognitiveDistance::Structures::CallNodeRoot.new
  end

  it "should always return itself on pop!" do
    @node.pop!.must_equal @node
  end

  it "should not have a context" do
    @node.context.is_a?(CognitiveDistance::Structures::MissingCallContext).must_equal true
  end

  it "should not yield itself when enumerating" do
    @node.inject(false) { |found, n|
      found || n.equal?(@node)
    }.must_equal false
  end

  it "should not include itself when converting to an array" do
    c1 = @node.push! 1, nil, nil, nil, nil
    c2 = @node.push! 2, nil, nil, nil, nil
    @node.to_a.must_equal [
      [c1, [] ],
      [c2, [] ]
    ]
  end
end

