module CognitiveDistance
  class << self
    def register_measurement mod, method, measurement
      register_generic "measure", mod, method, measurement
    end

    def register_grapher mod, method, grapher
      register_generic "graph", mod, method, grapher
    end

  private
    def register_generic prefix, mod, method, suffix
      instance_eval <<-EODEF, __FILE__, __LINE__
        def #{prefix}_#{suffix}(*args)
          #{mod.name}.#{method} *args
        end
      EODEF
    end
  end
end

require 'cognitive_distance/version'
require 'cognitive_distance/structures'
require 'cognitive_distance/tracer'
require 'cognitive_distance/measurements'
require 'cognitive_distance/transforms'
require 'cognitive_distance/presenters'

# Copyright 2012 Ian D. Eccles

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

