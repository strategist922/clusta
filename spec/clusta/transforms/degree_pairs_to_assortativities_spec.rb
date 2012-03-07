require 'spec_helper'

describe Clusta::Transforms::DegreePairsToAssortativities do

  it "undirected degree pairs" do
    transforming("degree_pairs/undirected.tsv", :with => "degree_pairs_to_assortativities").should have_output("assortativities/undirected.tsv")
  end
  
  it "handles directed degree pairs" do
    transforming("degree_pairs/directed.tsv", :with => "degree_pairs_to_assortativities").should have_output("assortativities/directed.tsv")
  end
  
end
