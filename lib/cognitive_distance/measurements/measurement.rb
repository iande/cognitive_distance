module CognitiveDistance::Measurements
  module Measurement
    def register name, measure=:measure
      CognitiveDistance.register_measurement self, measure, name 
    end
  end
end
