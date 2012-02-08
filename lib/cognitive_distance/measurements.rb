module CognitiveDistance::Measurements
  class << self
    def register_measurement mod, method, measurement
      instance_eval <<-EODEF, __FILE__, __LINE__
        def measure_#{measurement}(*args)
          #{mod.name}.#{method} *args
        end
      EODEF
    end
  end
end

require 'cognitive_distance/measurements/measurement'
require 'cognitive_distance/measurements/module_hops'
require 'cognitive_distance/measurements/distinct_module_hops'

