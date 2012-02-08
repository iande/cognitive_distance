module CognitiveDistance::Structures
  class Graph
    def initialize
      # The keys are the out-bound vertex
      @links = {}
    end

    def link from, *tos
      @links[from] ||= []
      @links[from] += tos
      self
    end

    def bilink n1, n2
      link n1, n2
      link n2, n1
      self
    end

    # Really?
    def vertices
      @links.inject([]) { |vs, (n, ns)|
        vs << n << ns
      }.flatten.uniq
    end

    def edges vertex=nil
      @links.inject([]) { |es, (n, ns)|
        es + (ns.map { |n2| [n, n2] })
      }
    end
    alias :to_a :edges

    def any_edges vertex
      edges.select { |(n1,n2)| n1 == vertex || n2 == vertex }
    end

    def in_edges vertex
      edges.select { |(n1,n2)| n2 == vertex }
    end

    # We could improve this because the keys of @links indicate the
    # out-bound edges for a given vertex, but for now let's go with
    # consistent
    def out_edges vertex
      edges.select { |(n1,n2)| n1 == vertex }
    end

    def empty?
      @links.empty?
    end

    # Two graphs are equal if they have the same edges and vertices
    # As our graphs do not contain any unlinked vertices, we can get by
    # with testing mutual inclusion of edges
    def == other
      return true if equal?(other) # save some time
      return false unless other.respond_to?(:to_a)
      e1s = to_a
      e2s = other.to_a
      e1s.size == e2s.size && e1s.all? { |e1| e2s.include? e1 }
    end

    # Duck-typing through `to_a` isn't enough, you actually have to be an instance
    # of Graph (or an instance of a subclass)
    def eql? other
      Graph === other && self == other
    end
  end
end

