module CognitiveDistance::Structures
  # Some special behavior on root
  class CallNodeRoot < CallNode
    # We never go looking for the parents of root.
    def pop! *args
      self
    end

    # A root node does not correspond to a trace line, thus has
    # no context, ever.
    def context
      NO_CONTEXT
    end

    # Do the same as CallNode, except we don't yield self.
    def each &block
      return enum_for(:each) unless block
      children.each do |node|
        node.each(&block)
      end
      self
    end
  end
end
