require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Measurements::Measures do
  it "registers a named measurement" do
    class MeasuresFoobar
      extend CognitiveDistance::Measurements::Measures
      measures :lameness
    end
    CognitiveDistance.must_respond_to :measure_lameness
  end

  it "performs the registered measurement" do
    class MeasuresFoobaz
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
    MeasuresFoobaz.received_args.must_equal ['foo', 'bar', 'blarg']
  end

  it "allows a measurement method to be defined" do
    class MeasuresFooboss
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
    MeasuresFooboss.received_args.must_equal [:x, :y, :z]
  end
end

