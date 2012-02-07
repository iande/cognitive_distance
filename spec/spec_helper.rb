if ENV['SCOV']
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
end

require 'minitest/autorun'
require 'minitest/emoji'
require 'cognitive_distance'

# Generally I'd mock these things, but we need valid trace_bindings
module CognitiveDistance::Test
  class TracesInternal
    def initialize v1=-6, v2=4, v3=9
      @v1 = v1
      @v2 = v2
      @v3 = v3
    end

    def method1
      8 * (method2 + method3)
    end

    def method2
      @v1 + method4
    end
    
    def method3
      @v2
    end
    
    def method4
      @v3
    end
  end

  class TracesModules
    def initialize
      @extern1 = TracesInternal.new
    end

    def hop_1_module
      some_constant
      @extern1.method1
    end

    def hop_2_modules
      @extern1.method1
      some_constant
      @extern1.method2
    end

    def hop_0_modules
      some_constant
    end

    def some_constant
      :truth
    end

    def hop_nested_modules
      #                      2
      nested = TracesModules.new
      # 1   + 2 = 3
      nested.hop_2_modules
      # 0
      some_constant
      # 1
      hop_1_module
      # total mod hops = 6
    end
  end
end

