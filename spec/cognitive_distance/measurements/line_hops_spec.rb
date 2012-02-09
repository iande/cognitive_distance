require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Measurements::LineHops do
  def make_tree
    CognitiveDistance::Structures::CallTree.new.tap do |tree|
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

  before do
    tree = @tree = make_tree
    # Stub out trace
    klass = CognitiveDistance::Tracer
    klass.send(:alias_method, :trace_orig, :trace)
    klass.send(:define_method, :trace) { |*_| tree }
    @measurement = CognitiveDistance::Measurements::LineHops.new
  end

  after do
    klass = CognitiveDistance::Tracer
    klass.send(:remove_method, :trace)
    klass.send(:alias_method, :trace, :trace_orig)
    klass.send(:remove_method, :trace_orig)
  end


  it "counts lines between call nodes" do
    @measurement.measure(@tree).must_equal 54
  end

  it "measures an object trace directly" do
    CognitiveDistance::Measurements::LineHops.measure(
      "test", :length).must_equal 54
  end

  it "registers its measurement" do
    CognitiveDistance.measure_line_hops("test", :length).must_equal 54
  end
end

