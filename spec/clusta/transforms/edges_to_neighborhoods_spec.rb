require 'spec_helper'

describe Clusta::Transforms::EdgesToNeighborhoods do

  it "handles undirected, unweighted edges" do
    transforming("edges/undirected.unweighted.tsv", :with => "edges_to_neighborhoods").should have_output("neighborhoods/undirected.unweighted.tsv")
  end

  it "handles undirected, weighted edges" do
    transforming("edges/undirected.weighted.tsv", :with => "edges_to_neighborhoods").should have_output("neighborhoods/undirected.weighted.tsv")
  end
  
  it "handles directed, unweighted edges" do
    transforming("edges/directed.unweighted.tsv", :with => "edges_to_neighborhoods").should have_output("neighborhoods/directed.unweighted.tsv")
  end
  
  it "handles directed, weighted edges" do
    transforming("edges/directed.weighted.tsv", :with => "edges_to_neighborhoods").should have_output("neighborhoods/directed.weighted.tsv")
  end
  
end
