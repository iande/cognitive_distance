require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Measurements::DistinctModuleHops do
  def get_meta_class klass
    klass.class_eval "class << self; self; end"
  end

  before do
    graph = @graph = MiniTest::Mock.new
    # Stub out transform
    klass = get_meta_class(CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph)
    klass.send(:alias_method, :transform_orig, :transform)
    klass.send(:define_method, :transform) { |*_| graph }
    @measurement = CognitiveDistance::Measurements::DistinctModuleHops.new
  end

  after do
    klass = get_meta_class(CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph)
    klass.send(:remove_method, :transform)
    klass.send(:alias_method, :transform, :transform_orig)
    klass.send(:remove_method, :transform_orig)
  end

  it "only counts distinct module boundary crossings" do
    tree = MiniTest::Mock.new
    @graph.expect :edges, [
      [ "module 1", "module 2" ],
      [ "module 1", "module 4" ],
      [ "module 1", "module 2" ]
    ]
    @measurement.measure(tree).must_equal 2
  end

end

