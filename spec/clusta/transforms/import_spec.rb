require 'spec_helper'

describe Clusta::Transforms::Import do

  it "handles undirected, unweighted edges" do
    transforming("external/vertices.tsv", :with => "import", :args => '--as=Vertex').should have_output("imports/vertices.labeled.tsv")
  end
  
end
