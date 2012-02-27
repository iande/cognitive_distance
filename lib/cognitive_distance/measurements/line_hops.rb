module CognitiveDistance::Measurements
  class LineHops
    extend Measures

    measures :line_hops

    def measure tree
      line_hops tree.to_a
    end

    class << self
      def measure &block
        new.measure trace_tree(&block)
      end

    private
      def trace_tree &block
        CognitiveDistance::Tracer.trace &block
      end
    end

  private
    def line_hops nodes
      nodes.inject(0) { |sum, (parent, children)|
        sum + line_hops_from_parent(parent, children)
      }
    end

    def line_hops_from_parent parent, children
      children.inject(0) { |sum, (c, _)|
        if c.trace_file == parent.trace_file
          sum + (c.trace_line - parent.trace_line).abs
        else
          sum
        end
      } + line_hops(children)
    end
  end
end

