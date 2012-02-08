module CognitiveDistance::Transforms
  class CallTreeToModuleBoundaryGraph
    def self.transform tree
      new.transform(tree)
    end

    def transform tree
      CognitiveDistance::Structures::Graph.new.tap do |graph|
        tree.to_a.each do |par|
          link_boundary_crossings graph, par, par.children
        end
      end
    end

  private
    def link_boundary_crossings graph, parent, children
      unless children.empty?
        children.each do |child|
          if !parent.context.equal?(child.context)
            graph.link parent, child
          end
          link_boundary_crossings graph, child, child.children
        end
      end
    end
  end
end

