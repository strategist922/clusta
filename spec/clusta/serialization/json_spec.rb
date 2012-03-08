require 'spec_helper'

describe Clusta::Serialization::JSON do

  def json_serializable_wrapper_class
    Class.new.tap do |c|
      c.send(:include, Clusta::Schema)
      c.send(:include, Clusta::Serialization)
      c.send(:include, Clusta::Serialization::JSON)
    end
  end

  before do
    @root = json_serializable_wrapper_class
    @root.key :foo

    @child = json_serializable_wrapper_class
    @child.key :baz

    @child.set_stream_name 'Child'
  end

  describe "processing inputs" do

    it "should assign a single key field correctly" do
      instance = @root.new("foovalue")
      instance.foo.should == "foovalue"
    end

    it "should assign a multiple key fields correctly" do
      @root.key :bar
      instance = @root.new("foovalue", "barvalue")
      instance.foo.should == "foovalue"
      instance.bar.should == "barvalue"
    end
    
    it "should assign and parse key and non-key fields when given as Ruby hashes" do
      @root.field :bar
      @root.field :baz
      instance = @root.new("foovalue", {"bar" => "barvalue", "baz" =>  "bazvalue"})
      instance.foo.should == "foovalue"
      instance.bar.should == "barvalue"
      instance.baz.should == "bazvalue"
    end

    it "should assign and parse key and non-key fields when given as a JSON string" do
      @root.field :bar
      @root.field :baz
      instance = @root.new("foovalue", '{"bar":"barvalue", "baz":"bazvalue"}')
      instance.foo.should == "foovalue"
      instance.bar.should == "barvalue"
      instance.baz.should == "bazvalue"
    end
    
    it "should assign a value to an optional field only if it's present" do
      @root.field :bar
      @root.field :baz, :optional => true
      instance = @root.new("foovalue", {"bar" => "barvalue"})
      instance.foo.should == "foovalue"
      instance.bar.should == "barvalue"
      instance.baz.should be_nil

      instance = @root.new("foovalue", {"bar" => "barvalue", "baz" => "bazvalue"})
      instance.foo.should == "foovalue"
      instance.bar.should == "barvalue"
      instance.baz.should == "bazvalue"
    end

    it "should stash extra arguments it receives at initialization" do
      @root.field :bar
      instance = @root.new("foovalue", {"bar" => "barvalue"}, "extra1", "extra2")
      instance.foo.should == "foovalue"
      instance.bar.should == "barvalue"
      instance.extra_inputs.size.should == 2
      instance.extra_inputs[0].should == "extra1"
      instance.extra_inputs[1].should == "extra2"
    end

  end
  
  describe "serializing" do

    it "returns an array appropriate for Wukong with a single key field" do
      output = @root.new("foovalue").to_flat
      output[0].should == @root.stream_name
      output[1].should == "foovalue"
    end

    it "returns an array appropriate for Wukong with a multiple key fields" do
      @root.key :bar
      output = @root.new("foovalue", "barvalue").to_flat
      output[0].should == @root.stream_name
      output[1].should == "foovalue"
      output[2].should == "barvalue"
    end

    it "returns an array appropriate for Wukong with keys and non key fields" do
      @root.field :bar
      output = @root.new("foovalue", { 'bar' => 'barvalue'}).to_flat
      output[0].should == @root.stream_name
      output[1].should == "foovalue"
      output[2].should match(/"bar" *: *"barvalue"/)
    end
    
    it "returns an array with an optional field at the end only if it has a value" do
      @root.field :bar, :optional => true
      output1 = @root.new("foovalue").to_flat
      output2 = @root.new("foovalue", {"bar" => "barvalue"}).to_flat

      output1.size.should == 2
      output1[0].should == @root.stream_name
      output1[1].should == 'foovalue'
      
      output2.size.should == 3
      output2[0].should == @root.stream_name
      output2[1].should == 'foovalue'
      output2[2].should match(/"bar" *: *"barvalue"/)
    end

    it "returns an array including any extra inputs it received as outputs" do
      @root.field :bar
      output = @root.new("foovalue", {"bar" => "barvalue"}, "extra1", "extra2").to_flat
      output.size.should == 5
      output[0].should == @root.stream_name
      output[1].should == "foovalue"
      output[2].should match(/"bar" *: *"barvalue"/)
      output[3].should == 'extra1'
      output[4].should == 'extra2'
    end
    
  end

end
