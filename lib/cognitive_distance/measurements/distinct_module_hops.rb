module CognitiveDistance::Measurements
  class DistinctModuleHops
    extend Measures
    
    measures :distinct_module_hops

    def measure tree
      CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph.
        transform(tree).map { |(v1,v2)|
          [v1.context, v2.context]
        }.uniq.size
    end

    class << self
      def measure &block
        new.measure trace_tree(&block)
      end

    private
      def trace_tree &block
        CognitiveDistance::Tracer.trace &block
      end
    end
  end
end

