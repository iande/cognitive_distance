require File.expand_path('../../../spec_helper', __FILE__)

module CognitiveDistance
  describe Measurements::DistinctModuleHops do
    include CognitiveDistance::Test::Stubbing

    before do
      @graph = Structures::Graph.new
      # Stub out transform
      stub(Transforms::CallTreeToModuleBoundaryGraph, :transform, @graph)
      @measurement = Measurements::DistinctModuleHops.new
      n1, n2, n3 = 3.times.map { |i| make_node "module #{i}" }
      n4 = make_node("module 0") # A different object, but the same context
      @graph.link n1, n2, n3
      @graph.link n4, n2
    end

    it "only counts distinct module boundary crossings" do
      tree = MiniTest::Mock.new
      @measurement.measure(tree).must_equal 2
    end

    it "measures an object trace directly" do
      # Even though this does create a real trace, we're still intercepting
      # the transformation, so we can honey badger away.
      Measurements::DistinctModuleHops.measure(
        "test", :length).must_equal 2
    end

    it "registers its measurement" do
      CognitiveDistance.measure_distinct_module_hops(
        "test", :length).must_equal 2
    end

    def make_node ctx
      mock = Structures::CallNode.new
      mock.trace_class = ctx
      stub(mock, :context, ctx)
      mock
    end
  end
end

