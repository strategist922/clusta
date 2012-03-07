require 'spec_helper'

describe Clusta::Serialization do

  before do
    @root = Class.new
    @root.send(:include, Clusta::Serialization)
  end

  it "defines a stream_name method for its class" do
    @root.stream_name.class.should == String
  end

  it "defines a stream_name method for its instances" do
    @root.new.stream_name.should == @root.stream_name
  end

  it "allows for abbreviating its stream name" do
    @root.abbreviate 'r'
  end

  it "allows for setting the stream name" do
    @root.set_stream_name 'root'
    @root.stream_name.should == 'root'
  end
  
end
