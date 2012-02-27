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
      def measure &block
        new.measure trace_tree(&block)
      end

      def graph &block
        new.graph trace_tree(&block)
      end

    private
      def trace_tree &block
        CognitiveDistance::Tracer.trace &block
      end
    end
  end
end

