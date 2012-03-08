require 'spec_helper'

describe Clusta::Transforms::PruneEdges do

  it "handles undirected, unweighted edges" do
    transforming("edges/undirected.unweighted.tsv", :with => "prune_edges", :args => '--min_weight=0.5 --max_weight=0.8').should have_output("pruned_edges/undirected.unweighted.tsv")
  end

  it "handles undirected, weighted edges" do
    transforming("edges/undirected.weighted.tsv", :with => "prune_edges", :args => '--min_weight=0.5 --max_weight=0.8').should have_output("pruned_edges/undirected.weighted.tsv")
  end
  
  it "handles directed, unweighted edges" do
    transforming("edges/directed.unweighted.tsv", :with => "prune_edges", :args => '--min_weight=0.5 --max_weight=0.8').should have_output("pruned_edges/directed.unweighted.tsv")
  end
  
  it "handles directed, weighted edges" do
    transforming("edges/directed.weighted.tsv", :with => "prune_edges", :args => '--min_weight=0.5 --max_weight=0.8').should have_output("pruned_edges/directed.weighted.tsv")
  end
  
  
end
