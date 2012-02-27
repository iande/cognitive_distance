module CognitiveDistance
  class Tracer
    class << self
      def trace &block
        __with_kernel_trace__ &block
      end
    private
      def __with_kernel_trace__
        tree = CognitiveDistance::Structures::CallTree.new
        # Ruby, I love you. Even if exceptions are raised, or catch/throw is
        # employed, you still give me a 'return' event as the stack unwinds.
        # *hug*
        Kernel.set_trace_func __make_tracer__(tree)
        yield rescue nil
        Kernel.set_trace_func nil
        tree
      end

      def __make_tracer__ tree
        lambda { |ev, fn, no, meth, bind, klass|
          case ev
          when 'call'
            tree.called klass, meth, fn, no, bind
          when 'return'
            tree.returned klass, meth, fn, no, bind
          end
        }
      end
    end
  end
end
