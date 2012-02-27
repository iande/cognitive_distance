module CognitiveDistance::Measurements
  class ModuleHops
    extend Measures
    extend Graphs

    measures :module_hops
    graphs :module_hops

    def measure tree
      graph(tree).edges.size
    end

    def graph tree
      CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph.
        transform(tree)
    end

    class << self
      def measure obj, meth
        new.measure(trace_tree(obj, meth))
      end

      def graph obj, meth
        new.graph(trace_tree(obj, meth))
      end

    private
      def trace_tree obj, meth
        CognitiveDistance::Tracer.trace { obj.__send__ meth }
      end
    end
  end
end

