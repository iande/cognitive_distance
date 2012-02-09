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
      def measure obj, meth
        new.measure(CognitiveDistance::Tracer.new(obj).trace(meth))
      end
    end
  end
end

