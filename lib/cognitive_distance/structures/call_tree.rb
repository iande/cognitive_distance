module CognitiveDistance::Structures
  class CallTree
    include Enumerable
    def initialize
      @root = CallNodeRoot.new
      @current_node = @root
    end

    def called k, m, f, l, b
      # Set the current node to the node given back
      @current_node = @current_node.push! k, m, f, l, b
      self
    end

    def returned k, m, f, l, b
      # Set the current node to the node given back
      @current_node = @current_node.pop! k, m, f, l, b
      self
    end

    def empty?
      @root.empty?
    end

    def size
      @root.size
    end

    # Returns the children of the root node for
    # when we need to traverse the trace like a tree
    def to_a
      @root.children
    end
    alias :to_arr :to_a

    def each &block
      @root.each(&block)
      self
    end

    def freeze
      @root.freeze
      @current_node = @root
      super
    end
  end
end
