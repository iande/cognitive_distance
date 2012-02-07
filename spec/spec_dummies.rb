# Generally I will favor mocks, but I need real bindings, and
# mocking those seemed just as tedious. Thus, dummies.

module CognitiveDistance::Test

  # None of this guy's methods cross into another
  # Ruby class
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

  # This guy has methods that will cross various module boundaries.
  # The method names should remove the mystery of how many are crossed.
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

    def another_constant
      :less_truth
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

  # A module to be included to verify that invoking included methods
  # does *not* count as crossing a module boundary. There are two
  # directions to test (instance method => module method, and
  # module method => instance method), hence there are two methods.
  module IncludeThis
    def from_included_to_obj
      some_constant
    end

    def included_constant
      :included
    end
  end

  # Includes the above module, and subclasses another dummy.
  # This is the guy we use to verify that neither inherited or
  # mixed-in methods count as crossing a module boundary.
  class TracesModulesSub < TracesModules
    include IncludeThis

    def from_obj_to_included
      included_constant
    end

    def from_base_to_super
      another_constant
    end

    # This ensures that calling `hop_0_modules` calls from super to base
    def some_constant
      :more_truth
    end
  end
end

