require 'spec_helper'

describe Clusta::Transforms::EdgesToVertexArrows do

  it "handles undirected, unweighted edges" do
    transforming("edges/undirected.unweighted.tsv", :with => "edges_to_vertex_arrows").should have_output("vertex_arrows/undirected.unweighted.tsv")
  end

  it "handles undirected, weighted edges" do
    transforming("edges/undirected.weighted.tsv", :with => "edges_to_vertex_arrows").should have_output("vertex_arrows/undirected.weighted.tsv")
  end
  
  it "handles directed, unweighted edges" do
    transforming("edges/directed.unweighted.tsv", :with => "edges_to_vertex_arrows").should have_output("vertex_arrows/directed.unweighted.tsv")
  end
  
  it "handles directed, weighted edges" do
    transforming("edges/directed.weighted.tsv", :with => "edges_to_vertex_arrows").should have_output("vertex_arrows/directed.weighted.tsv")
  end
  
end
