module CognitiveDistance::Transforms
  class CallTreeToModuleBoundaryGraph
    def self.transform tree
      new.transform(tree)
    end

    def transform tree
      CognitiveDistance::Structures::Graph.new.tap do |graph|
        link_nodes graph, tree.to_a
      end
    end

  private
    def link_nodes graph, node_arr
      node_arr.each do |parent, children|
        link_boundary_crossings graph, parent, children
      end
   end

    def link_boundary_crossings graph, parent, children
      children.each do |(child, _)|
        if !parent.context.equal?(child.context)
          graph.link parent, child
        end
      end
      link_nodes graph, children
    end
  end
end

