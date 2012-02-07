require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Measurements::ModuleHops do

  describe "the basics" do
    before do
      @measurement = CognitiveDistance::Measurements::ModuleHops.new
      @traced = CognitiveDistance::Test::TracesModules.new
      @tracer = CognitiveDistance::Tracer.new(@traced)
    end

    it "counts a single module boundary crossing" do
      tree = @tracer.trace(:hop_1_module)
      @measurement.measure(tree).must_equal 1
    end

    it "counts no boundary crossings" do
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

  describe "with subclases and includes" do
    before do
      @measurement = CognitiveDistance::Measurements::ModuleHops.new
      @traced = CognitiveDistance::Test::TracesModulesSub.new
      @tracer = CognitiveDistance::Tracer.new(@traced)
    end

    it "does not count calls from object to included" do
      tree = @tracer.trace(:from_obj_to_included)
      @measurement.measure(tree).must_equal 0
    end

    it "does not count calls from included to object" do
      tree = @tracer.trace(:from_included_to_object)
      @measurement.measure(tree).must_equal 0
    end
    
    it "does not count calls from base to super" do
      tree = @tracer.trace(:from_base_to_super)
      @measurement.measure(tree).must_equal 0
    end

    it "does not count calls from super to base" do
      tree = @tracer.trace(:hop_0_modules)
      @measurement.measure(tree).must_equal 0
    end
  end
end
