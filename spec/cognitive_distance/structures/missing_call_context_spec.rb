require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Structures::MissingCallContext do
  before do
    @missing_call_context = CognitiveDistance::Structures::MissingCallContext.new
  end

  it "is not equal to some other object" do
    @missing_call_context.equal?("test string").must_equal false
  end

  it "is not equal to another missing call context" do
    other = CognitiveDistance::Structures::MissingCallContext.new
    @missing_call_context.equal?(other).must_equal false
  end

  it "is not equal to itself" do
    @missing_call_context.equal?(@missing_call_context).must_equal false
  end
end

