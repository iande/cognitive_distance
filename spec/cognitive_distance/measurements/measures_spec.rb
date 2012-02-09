require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Measurements::Measures do
  it "registers a named measurement" do
    class Foobar
      extend CognitiveDistance::Measurements::Measures
      measures :lameness
    end
    CognitiveDistance.must_respond_to :measure_lameness
  end

  it "performs the registered measurement" do
    class Foobaz
      extend CognitiveDistance::Measurements::Measures
      measures :suckiness

      class << self
        attr_reader :received_args
        def measure *args
          @received_args = args
        end
      end
    end
    CognitiveDistance.measure_suckiness('foo', 'bar', 'blarg')
    Foobaz.received_args.must_equal ['foo', 'bar', 'blarg']
  end

  it "allows a measurement method to be defined" do
    class Fooboss
      extend CognitiveDistance::Measurements::Measures
      measures :unfortunately, :most_unfortunate

      class << self
        attr_reader :received_args
        def most_unfortunate *args
          @received_args = args
        end
      end
    end
    CognitiveDistance.measure_unfortunately(:x, :y, :z)
    Fooboss.received_args.must_equal [:x, :y, :z]
  end
end

