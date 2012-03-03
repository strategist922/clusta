require 'spec_helper'

describe Clusta::Transforms::EdgesToDegrees do

  it "handles undirected, unweighted edges" do
    transforming("edges/undirected.unweighted.tsv", :with => "edges_to_degrees").should have_output("degrees/undirected.tsv")
  end

  it "handles undirected, weighted edges" do
    transforming("edges/undirected.weighted.tsv", :with => "edges_to_degrees").should have_output("degrees/undirected.tsv")
  end
  
  it "handles directed, unweighted edges" do
    transforming("edges/directed.unweighted.tsv", :with => "edges_to_degrees").should have_output("degrees/directed.tsv")
  end
  
  it "handles directed, weighted edges" do
    transforming("edges/directed.weighted.tsv", :with => "edges_to_degrees").should have_output("degrees/directed.tsv")
  end
  
  
end
