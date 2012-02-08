require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Measurements::DistinctModuleHops do
  def get_meta_class klass
    klass.class_eval "class << self; self; end"
  end

  def make_node ctx
    mock = CognitiveDistance::Structures::CallNode.new
    mock.trace_class = ctx
    def mock.context
      trace_class
    end
    mock
  end

  before do
    graph = @graph = CognitiveDistance::Structures::Graph.new
    # Stub out transform
    klass = get_meta_class(CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph)
    klass.send(:alias_method, :transform_orig, :transform)
    klass.send(:define_method, :transform) { |*_| graph }
    @measurement = CognitiveDistance::Measurements::DistinctModuleHops.new
    n1, n2, n3 = 3.times.map { |i| make_node "module #{i}" }
    n4 = make_node("module 0") # A different object, but the same context
    @graph.link n1, n2, n3
    @graph.link n4, n2
  end

  after do
    klass = get_meta_class(CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph)
    klass.send(:remove_method, :transform)
    klass.send(:alias_method, :transform, :transform_orig)
    klass.send(:remove_method, :transform_orig)
  end

  it "only counts distinct module boundary crossings" do
    tree = MiniTest::Mock.new
    @measurement.measure(tree).must_equal 2
  end

  it "measures an object trace directly" do
    # Even though this does create a real trace, we're still intercepting
    # the transformation, so we can honey badger away.
    CognitiveDistance::Measurements::DistinctModuleHops.measure("test", :length).must_equal 2
  end

  it "registers its measurement" do
    CognitiveDistance::Measurements.measure_distinct_module_hops("test", :length).must_equal 2
  end
end

