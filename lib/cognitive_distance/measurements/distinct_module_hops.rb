module CognitiveDistance::Measurements
  class DistinctModuleHops
    def measure tree
      CognitiveDistance::Transforms::CallTreeToModuleBoundaryGraph.
        transform(tree).edges.uniq.size
    end
  end
end

