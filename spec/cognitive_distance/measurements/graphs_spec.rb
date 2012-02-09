require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Measurements::Graphs do
  it "registers a named grapher" do
    class GraphsFoobar
      extend CognitiveDistance::Measurements::Graphs
      graphs :lameness
    end
    CognitiveDistance.must_respond_to :graph_lameness
  end

  it "performs the registered graphing" do
    class GraphsFoobaz
      extend CognitiveDistance::Measurements::Graphs
      graphs :suckiness

      class << self
        attr_reader :received_args
        def graph *args
          @received_args = args
        end
      end
    end
    CognitiveDistance.graph_suckiness('foo', 'bar', 'blarg')
    GraphsFoobaz.received_args.must_equal ['foo', 'bar', 'blarg']
  end

  it "allows a graph method to be defined" do
    class GraphsFooboss
      extend CognitiveDistance::Measurements::Graphs
      graphs :unfortunately, :most_unfortunate

      class << self
        attr_reader :received_args
        def most_unfortunate *args
          @received_args = args
        end
      end
    end
    CognitiveDistance.graph_unfortunately(:x, :y, :z)
    GraphsFooboss.received_args.must_equal [:x, :y, :z]
  end
end

