module CognitiveDistance::Structures
  class CallNode
    include Enumerable

    NO_CONTEXT = MissingCallContext.new.freeze
    attr_reader :children, :parent
    attr_accessor :trace_file, :trace_line, :trace_class,
                  :trace_method, :trace_binding

    def initialize par=nil
      @parent = par
      @children = []
      yield self if block_given?
    end

    # Create a new call node, add it to children and return it
    def push! k, m, f, l, b
      CallNode.new(self) do |node|
        node.trace_file    = f
        node.trace_line    = l
        node.trace_class   = k
        node.trace_method  = m
        node.trace_binding = b
      end.tap do |node|
        children << node
      end
    end

    # TODO: Maybe we shouldn't blindly assume that the pop! belongs
    # to us?
    def pop! *args # k, m, f, l, b
      parent
    end

    def context
      @context ||= create_context
      @context
    end

    def each &block
      return enum_for(:each) unless block
      yield self
      children.each do |node|
        node.each(&block)
      end
      self
    end

    def empty?
      children.empty?
    end

    def size
      children.inject(children.size) { |s,c| s + c.size }
    end

    def freeze
      context # Ensure context is set
      children.each(&:freeze)
      children.freeze
      super
    end

  private
    def create_context
      trace_binding.eval("self") rescue NO_CONTEXT
    end
  end
end

