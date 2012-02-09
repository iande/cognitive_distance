require File.expand_path('../spec_helper', __FILE__)

describe CognitiveDistance do
  class SuckySuckSucks
    class << self
      attr_reader :lameness_args, :sweetness_args
      def lameness *args
        @lameness_args = args
      end
      def sweetness *args
        @sweetness_args = args
      end
    end
  end
  
  it "registers a measurement" do
    CognitiveDistance.register_measurement SuckySuckSucks, :lameness, :beefcake
    CognitiveDistance.measure_beefcake :x, :y, :z
    SuckySuckSucks.lameness_args.must_equal [:x, :y, :z]
  end

  it "registers a grapher" do
    CognitiveDistance.register_grapher SuckySuckSucks, :sweetness, :beefcake
    CognitiveDistance.graph_beefcake :t, :u, :v
    SuckySuckSucks.sweetness_args.must_equal [:t, :u, :v]
  end
end


