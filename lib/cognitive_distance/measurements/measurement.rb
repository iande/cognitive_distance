module CognitiveDistance::Measurements
  module Measurement
    def register name, measure_with=:measure
      CognitiveDistance::Measurements.instance_eval <<-EODEF
        def measure_#{name}(*args)
          #{self}.#{measure_with}(*args)
        end
      EODEF
    end
  end
end
