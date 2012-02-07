require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Measurements::ModuleHops do
  before do
    @measurement = CognitiveDistance::Measurements::ModuleHops.new
    @traced = CognitiveDistance::Test::TracesModules.new
    @tracer = CognitiveDistance::Tracer.new(@traced)
  end

  it "counts a single module boundary crossing" do
    tree = @tracer.trace(:hop_1_module)
    # Convert calltree to array
    #   over each element, perform the calculation through the tree
    # Aggregate the results
    @measurement.measure(tree).must_equal 1
  end

  it "counts no module boundary crossings" do
    tree = @tracer.trace(:hop_0_modules)
    @measurement.measure(tree).must_equal 0
  end

  it "counts multiple boundary crossings" do
    tree = @tracer.trace(:hop_2_modules)
    @measurement.measure(tree).must_equal 2
  end

  it "counts nested boundary crossings" do
    tree = @tracer.trace(:hop_nested_modules)
    @measurement.measure(tree).must_equal 6
  end
end
