require 'erb'

module CognitiveDistance::Presenters
  class GraphToDot
    def template_file
      File.expand_path('../../../../resources/templates/digraph_dot.erb', __FILE__)
    end

    def present graph, name='graphname', &labeler
      labeler ||= lambda { |v| v.to_s }
      template = ERB.new(File.read(template_file))
      template.result binding
    end
  end
end

