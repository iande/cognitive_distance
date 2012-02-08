module CognitiveDistance
  # TODO: What happens if an exception percolates up?
  # We probably do not get a valid trace from this:
  #
  #     def meth1
  #       meth2
  #     rescue
  #     end
  #     def meth2
  #       meth3
  #     end
  #     def meth3
  #       raise "Eat it"
  #     end
  # 
  class Tracer
    def initialize measured
      @traced = measured
    end

    def trace *args, &block
      __with_kernel_trace__ do
        @traced.__send__ *args, &block
      end
    end

  private
    def __with_kernel_trace__
      tree = CognitiveDistance::Structures::CallTree.new
      # Ruby, I love you. Even if exceptions are raised, or catch/throw is
      # employed, you still give me a 'return' event as the stack unwinds.
      # *hug*
      Kernel.set_trace_func lambda { |ev, fn, no, meth, bind, klass|
        case ev
        when 'call'
          tree.called klass, meth, fn, no, bind
        when 'return'
          tree.returned klass, meth, fn, no, bind
        end
      }
      yield rescue nil
      ::Kernel.set_trace_func nil
      tree
    end
  end
end
