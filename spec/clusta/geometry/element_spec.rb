require 'spec_helper'

describe Clusta::Geometry::Element do

  describe "setting inheritable fields" do

    it "should not define any fields of its own" do
      Clusta::Geometry::Element.fields.should == []
    end

    it "should allow a subclass to set its own fields without polluting the parent" do
      wrapper = Class.new(Clusta::Geometry::Element)
      wrapper.field :foo
      Clusta::Geometry::Element.field_names.should_not include('foo')
      wrapper.field_names.should include('foo')
    end

    it "should allow a subclass of a subclass to set its own fields without polluting the parent" do
      wrapper1 = Class.new(Clusta::Geometry::Element)
      wrapper1.field :foo
      wrapper2 = Class.new(wrapper1)
      wrapper2.field :bar
      
      Clusta::Geometry::Element.field_names.should_not include('foo')
      Clusta::Geometry::Element.field_names.should_not include('bar')
      
      wrapper1.field_names.should include('foo')
      wrapper1.field_names.should_not include('bar')

      wrapper2.field_names.should include('foo')
      wrapper2.field_names.should include('bar')
    end
    
  end

  describe "initializing" do

    it "should assign declared fields" do
      wrapper = Class.new(Clusta::Geometry::Element)
      wrapper.field :foo
      wrapper.field :baz
      instance = wrapper.new("bar", "boof")
      instance.foo.should == "bar"
      instance.baz.should == "boof"
    end

    it "should allow for an optional field at the end" do
      wrapper = Class.new(Clusta::Geometry::Element)
      wrapper.field :foo
      wrapper.field :baz, :optional => true
      instance = wrapper.new("bar")
      instance.foo.should == "bar"
      instance.baz.should == nil

      instance = wrapper.new("bar", "boof")
      instance.foo.should == "bar"
      instance.baz.should == "boof"
    end
    
  end
  
  describe "serializing" do

    it "constructs an array" do
      wrapper = Class.new(Clusta::Geometry::Element)
      wrapper.field :foo
      wrapper.field :baz
      wrapper.new("bar", "boof").to_flat[1].should == 'bar'
      wrapper.new("bar", "boof").to_flat[2].should == 'boof'
    end

    it "constructs an array with optional fields" do
      wrapper = Class.new(Clusta::Geometry::Element)
      wrapper.field :foo
      wrapper.field :baz, :optional => true
      wrapper.new("bar").to_flat[2].should == nil
      wrapper.new("bar", "boof").to_flat[2].should == 'boof'
    end
    
  end

end

