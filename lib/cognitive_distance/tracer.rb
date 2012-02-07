module CognitiveDistance
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
      tree = CognitiveDistance::CallTree.new
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
