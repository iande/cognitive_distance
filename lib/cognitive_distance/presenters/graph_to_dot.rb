module CognitiveDistance::Presenters
  class GraphToDot
    def present graph, name='graphname', &label
      label ||= lambda { |v| v.to_s }
      "digraph #{name.to_s.inspect} {\n" + graph.inject("") { |str, (v1,v2)|
        str << "#{label[v1].inspect} -> #{label[v2].inspect};\n"
      } + "}"
    end
  end
end

