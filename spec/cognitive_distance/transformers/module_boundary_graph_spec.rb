require File.expand_path('../../../spec_helper', __FILE__)

describe CognitiveDistance::Transformers::ModuleBoundaryGraph do
  # What is a module boundary graph?
  # It should be a graph (duh) where nodes represent
  # modules/classes and the edges indicate
  # a call that crossed that boundary. Edges can be weighted, indicating the
  # number of times that boundary was crossed

  it "should transform a CallTree into a graph of boundary crossings" do
    flunk "Nope"
  end
end

