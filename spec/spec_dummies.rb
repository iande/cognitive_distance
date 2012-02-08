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

    def test_throwing
      catch(:tang) do
        prepare_the_throwing
      end
      method4
    end

    def prepare_the_throwing
      do_the_throwing
    end
    
    def do_the_throwing
      throw :tang
    end

    def test_raising
      prepare_the_raising rescue nil
      method3
    end

    def prepare_the_raising
      do_the_raising
    end

    def do_the_raising
      raise "Suck it dipped in Tang"
    end
  end
end

