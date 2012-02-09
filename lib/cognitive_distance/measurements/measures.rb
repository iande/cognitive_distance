module CognitiveDistance::Measurements
  module Measures
    def measures name, measure=:measure
      CognitiveDistance.register_measurement self, measure, name 
    end
  end
end
