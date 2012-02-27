require File.expand_path('../../../spec_helper', __FILE__)

module CognitiveDistance
  describe Measurements::LineHops do
    include CognitiveDistance::Test::Stubbing

    before do
      @tree = make_tree
      # Stub out trace
      stub(Tracer, :trace, @tree)
      @measurement = CognitiveDistance::Measurements::LineHops.new
    end

    it "counts lines between call nodes" do
      @measurement.measure(@tree).must_equal 54
    end

    it "counts nothing when no common files are traversed" do
      @measurement.measure(make_zero_tree).must_equal 0
    end

    it "measures an object trace directly" do
      Measurements::LineHops.measure(
        "test", :length).must_equal 54
    end

    it "registers its measurement" do
      CognitiveDistance.measure_line_hops("test", :length).must_equal 54
    end
    
    def make_tree
      Structures::CallTree.new.tap do |tree|
        tree.called nil, nil, "file1", 10, nil

        tree.called nil, nil, "file1", 2, nil     # +  8
        tree.returned nil, nil, "file1", 4, nil

        tree.called nil, nil, "file2", 10, nil    # +  0
        tree.called nil, nil, "file2", 48, nil    # + 38
        tree.called nil, nil, "file3", 107, nil   # +  0
        tree.called nil, nil, "file3", 115, nil   # +  8
        tree.returned nil, nil, "file3", 115, nil
        tree.returned nil, nil, "file3", 110, nil
        tree.returned nil,  nil, "file2", 61, nil
        tree.returned nil, nil, "file2", 14, nil

        tree.returned nil, nil, "file1", 11, nil # = 54
      end
    end

    def make_zero_tree
      Structures::CallTree.new.tap do |tree|
        tree.called nil, nil, "file1", 10, nil

        tree.called nil, nil, "file2", 2, nil     # +  0
        tree.returned nil, nil, "file2", 4, nil

        tree.called nil, nil, "file3", 10, nil    # +  0
        tree.called nil, nil, "file4", 48, nil    # +  0
        tree.called nil, nil, "file5", 107, nil   # +  0
        tree.called nil, nil, "file6", 115, nil   # +  0
        tree.returned nil, nil, "file6", 115, nil
        tree.returned nil, nil, "file5", 110, nil
        tree.returned nil,  nil, "file4", 61, nil
        tree.returned nil, nil, "file3", 14, nil

        tree.returned nil, nil, "file1", 11, nil # = 0
      end
    end
  end
end
