module CognitiveDistance::Measurements
  class ModuleHops
    extend Measurement
    
    register :module_hops

    def measure tree
      CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph.
        transform(tree).edges.size
    end

    def self.measure obj, meth
      new.measure(CognitiveDistance::Tracer.new(obj).trace(meth))
    end
  end
end

