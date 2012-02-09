require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Measurements::ModuleHops do
  def get_meta_class klass
    klass.class_eval "class << self; self; end"
  end

  before do
    graph = @graph = Object.new
    def graph.edges
      [
        [ "module 1", "module 2" ],
        [ "module 1", "module 4" ],
        [ "module 1", "module 2" ]
      ]
    end
    # Stub out transform
    klass = get_meta_class(CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph)
    klass.send(:alias_method, :transform_orig, :transform)
    klass.send(:define_method, :transform) { |*_| graph }
    @measurement = CognitiveDistance::Measurements::ModuleHops.new
  end

  after do
    klass = get_meta_class(CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph)
    klass.send(:remove_method, :transform)
    klass.send(:alias_method, :transform, :transform_orig)
    klass.send(:remove_method, :transform_orig)
  end

  it "only counts all module boundary crossings" do
    tree = MiniTest::Mock.new
    @measurement.measure(tree).must_equal 3
  end

  it "measures an object trace directly" do
    # Even though this does create a real trace, we're still intercepting
    # the transformation, so we can honey badger away.
    CognitiveDistance::Measurements::ModuleHops.measure("test", :length).must_equal 3
  end

  it "graphs module boundary crossings" do
    tree = MiniTest::Mock.new
    @measurement.graph(tree).must_equal @graph
  end

  it "graphs an object trace directly" do
    CognitiveDistance::Measurements::ModuleHops.graph("test", :length).must_equal @graph
  end

  it "registers its measurement" do
    CognitiveDistance.measure_module_hops("test", :length).must_equal 3
  end

  it "registers its grapher" do
    CognitiveDistance.graph_module_hops("test", :length).must_equal @graph
  end
end

