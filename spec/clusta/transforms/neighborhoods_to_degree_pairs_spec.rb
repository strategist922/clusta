require 'spec_helper'

describe Clusta::Transforms::NeighborhoodsToDegreePairs do

  it "handles undirected, unweighted neighborhoods" do
    transforming("neighborhoods/undirected.unweighted.tsv", :with => "neighborhoods_to_degree_pairs").should have_output("degree_pairs/undirected.tsv")
  end

  it "handles undirected, weighted neighborhoods" do
    transforming("neighborhoods/undirected.weighted.tsv", :with => "neighborhoods_to_degree_pairs").should have_output("degree_pairs/undirected.tsv")
  end
  
  it "handles directed, unweighted neighborhoods" do
    transforming("neighborhoods/directed.unweighted.tsv", :with => "neighborhoods_to_degree_pairs").should have_output("degree_pairs/directed.tsv")
  end
  
  it "handles directed, weighted neighborhoods" do
    transforming("neighborhoods/directed.weighted.tsv", :with => "neighborhoods_to_degree_pairs").should have_output("degree_pairs/directed.tsv")
  end
  
end
