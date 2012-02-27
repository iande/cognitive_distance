require File.expand_path('../../../spec_helper', __FILE__)
require 'json'

describe CognitiveDistance::Presenters::GraphToD3JSON do
  # I believe d3 is pretty flexible as far as its json data is concerned,
  # but I'm shooting for something that resembles:
  #     http://mbostock.github.com/d3/ex/miserables.json

  before do
    @presenter = CognitiveDistance::Presenters::GraphToD3JSON.new
    @graph = CognitiveDistance::Structures::Graph.new
    @graph.link :a, :b, :c
    @graph.link :b, :c
    @graph.link :a, :c
  end
  
  it "converts a graph to a suitable json format suitable for d3"
end

