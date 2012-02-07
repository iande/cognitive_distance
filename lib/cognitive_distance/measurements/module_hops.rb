module CognitiveDistance::Measurements
  class ModuleHops
    def measure tree
      tree.to_a.inject(0) { |sum, node|
        sum + count_node(node)
      }
    end

  private
    def count_node node
      node.children.inject(0) { |crossed, child|
        crossed + count_crossing(node, child) + count_node(child)
      }
    end

    def count_crossing parent, child
      parent.context.equal?(child.context) ? 0 : 1
    end
  end
end

