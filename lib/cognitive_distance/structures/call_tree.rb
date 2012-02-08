require 'forwardable'

module CognitiveDistance::Structures
  class CallTree
    extend Forwardable
    include Enumerable

    def_delegators :@root, :empty?, :size, :to_a, :each
    attr_reader :root

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

    def freeze
      @root.freeze
      @current_node = @root
      super
    end
  end
end
