module CognitiveDistance::Measurements
  module Graphs
    def graphs name, meth=:graph
      CognitiveDistance.register_grapher self, meth, name
    end
  end
end

