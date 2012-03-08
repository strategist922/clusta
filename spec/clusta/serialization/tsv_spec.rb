require 'spec_helper'

describe Clusta::Serialization::TSV do

  def tsv_serializable_wrapper_class
    Class.new.tap do |c|
      c.send(:include, Clusta::Schema)
      c.send(:include, Clusta::Serialization)
      c.send(:include, Clusta::Serialization::TSV)
    end
  end

  before do
    @root = tsv_serializable_wrapper_class
    @root.key :foo

    @child = tsv_serializable_wrapper_class
    @child.key :baz

    @child.set_stream_name 'Child'
  end

  describe "processing inputs" do

    it "should assign declared fields" do
      instance = @root.new("foovalue")
      instance.foo.should == "foovalue"
    end

    it "should parse and assign a declared child element field" do
      @root.field :child, :type => :geometry
      instance = @root.new("foovalue", "Child;bazvalue")
      instance.foo.should == "foovalue"
      instance.child.class.should == @child
      instance.child.baz.should == "bazvalue"
    end

    it "should assign a value to an optional field only if it's present" do
      @root.field :bar, :optional => true
      
      instance = @root.new("foovalue")
      instance.foo.should == "foovalue"
      instance.bar.should == nil

      instance = @root.new("foovalue", "barvalue")
      instance.foo.should == "foovalue"
      instance.bar.should == "barvalue"
    end

    it "should stash extra arguments it receives at initialization" do
      instance = @root.new("foovalue", "barvalue")
      instance.foo.should == "foovalue"
      instance.extra_inputs.size.should == 1
      instance.extra_inputs[0].should == "barvalue"
    end

    it "should parse and stash structured child elements in the extra arguments it receives at initialization" do
      instance = @root.new("foovalue", "Child;bazvalue")
      instance.foo.should == "foovalue"
      instance.extra_inputs.size.should == 1
      instance.extra_inputs[0].class.should == @child
      instance.extra_inputs[0].baz.should == "bazvalue"
    end

  end
  
  describe "serializing" do

    it "returns an array appropriate for Wukong" do
      output = @root.new("foovalue").to_flat
      output[0].should == @root.stream_name
      output[1].should == "foovalue"
    end

    it "returns an array with an optional field at the end only if it has a value" do
      @root.field :bar, :optional => true
      output1 = @root.new("foovalue").to_flat
      output2 = @root.new("foovalue", "barvalue").to_flat

      output1.size.should == 2
      output1[0].should == @root.stream_name
      output1[1].should == 'foovalue'
      
      output2.size.should == 3
      output2[0].should == @root.stream_name
      output2[1].should == 'foovalue'
      output2[2].should == 'barvalue'
    end

    it "returns an array including any extra inputs it received" do
      output = @root.new("foovalue", "barvalue").to_flat
      output.size.should == 3
      output[0].should == @root.stream_name
      output[1].should == "foovalue"
      output[2].should == "barvalue"
    end
    
    it "returns an array including any extra inputs it received as well as optional inputs" do
      @root.field :bar, :optional => true
      
      instance = @root.new("foovalue", "barvalue", "extra1", "extra2")
      instance.foo.should == 'foovalue'
      instance.bar.should == 'barvalue'
      instance.extra_inputs.should == ['extra1', 'extra2']

      instance = @root.new("foovalue")
      instance.foo.should == 'foovalue'
      instance.bar.should be_nil
      instance.extra_inputs.should be_empty
    end

    it "returns an array with properly serialized geometry fields" do
      @root.field :bar, :type => :geometry
      output = @root.new("foovalue", "Child;bazvalue").to_flat
      output.size.should == 3
      output[0].should == @root.stream_name
      output[1].should == "foovalue"
      output[2].should == "Child;bazvalue"
    end

    it "returns an array with properly serialized geometry fields when they were given as extra inputs" do
      output = @root.new("foovalue", "Child;bazvalue").to_flat
      output.size.should == 3
      output[0].should == @root.stream_name
      output[1].should == "foovalue"
      output[2].should == "Child;bazvalue"
    end
    
    
    
  end

end
