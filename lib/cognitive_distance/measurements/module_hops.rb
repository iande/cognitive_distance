module CognitiveDistance::Measurements
  class ModuleHops
    def measure tree
      CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph.
        transform(tree).edges.size
    end
  end
end

