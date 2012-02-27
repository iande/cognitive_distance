require File.expand_path('../../spec_helper', __FILE__)

module CognitiveDistance
  describe Tracer do
    before do
      @traced = CognitiveDistance::Test::TracesInternal.new
    end

    def to_methods arr
      arr.map { |(node, children)|
        [node.trace_method, to_methods(children)]
      }
    end

    it "returns a CallTree after tracing" do
      call_tree = Tracer.trace { @traced.method1 }
      call_tree.is_a?(CognitiveDistance::Structures::CallTree).must_equal true
      call_tree.to_a.size.must_equal 1
    end

    it "traces out a CallTree" do
      call_tree = Tracer.trace { @traced.method1 }
      to_methods(call_tree.to_a).must_equal [
        [:method1, [
          [:method2, [
            [:method4, []]
      ]],
        [:method3, []]
      ]]
      ]
    end

    it "traces out multiple calls" do
      call_tree = CognitiveDistance::Tracer.trace do
        @traced.method1
        @traced.method4
        @traced.method3
      end
      to_methods(call_tree.to_a).must_equal [
        [:method1, [
          [:method2, [
            [:method4, []]
      ]],
        [:method3, []]
      ]],
        [:method4, []],
        [:method3, []]
      ]
    end

    it "traces out properly when an exception is raised" do
      call_tree = Tracer.trace { @traced.test_raising }
      to_methods(call_tree.to_a).must_equal [
        [:test_raising, [
          [:prepare_the_raising, [
            [ :do_the_raising, [] ]
      ]],
        [:method3, []]
      ]]
      ]
    end

    it "traces out properly when throwing and catching" do
      call_tree = Tracer.trace { @traced.test_throwing }
      to_methods(call_tree.to_a).must_equal [
        [:test_throwing, [
          [:prepare_the_throwing, [
            [ :do_the_throwing, [] ]
      ]],
        [:method4, []]
      ]]
      ]
    end
  end
end
