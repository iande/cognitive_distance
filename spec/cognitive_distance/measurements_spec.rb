require File.expand_path('../../spec_helper', __FILE__)

describe CognitiveDistance::Measurements do
  class SuckySuckSucks
    class << self
      attr_reader :lameness_args
      def lameness *args
        @lameness_args = args
      end
    end
  end
  
  it "registers a measurement" do
    CognitiveDistance::Measurements.register_measurement SuckySuckSucks, :lameness, :beefcake
    CognitiveDistance::Measurements.measure_beefcake :x, :y, :z
    SuckySuckSucks.lameness_args.must_equal [:x, :y, :z]
  end
end

