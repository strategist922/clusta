require 'spec_helper'

describe Clusta::Geometry::Element do

  describe "setting inheritable fields" do

    before do
      Wukong::RESOURCE_CLASS_MAP.clear
    end

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

    it "should not allow for more than one optional field" do
      wrapper = Class.new(Clusta::Geometry::Element)
      wrapper.field :foo, :optional => true
      lambda { wrapper.field :bar, :optional => true }.should raise_error
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

  describe "dealing with fields beyond those declared" do

    it "should accept additional fields by default" do
      instance = Clusta::Geometry::Element.new("foo", "bar", "baz")
      instance.input_fields.should include("foo", "bar", "baz")
    end

    it "should serialize additional fields properly" do
      instance = Clusta::Geometry::Element.new("foo", "bar", "baz")
      instance.to_flat.should include("foo", "bar", "baz")
    end
    
    it "should accept additional fields on a subclass" do
      wrapper = Class.new(Clusta::Geometry::Element)
      wrapper.field :foo
      instance = wrapper.new("foovalue", "bar", "baz")
      instance.foo.should == "foovalue"
      instance.input_fields.should include("bar", "baz")
    end

    it "should serialize additional fields on a subclass properly" do
      wrapper = Class.new(Clusta::Geometry::Element)
      wrapper.field :foo
      instance = wrapper.new("foovalue", "bar", "baz")
      instance.to_flat.should include("foovalue", "bar", "baz")
    end

    it "should allow a subclass to alias input_fields" do
      wrapper = Class.new(Clusta::Geometry::Element)
      wrapper.field :foo
      wrapper.input_fields :bar
      instance = wrapper.new("foovalue", "bar", "baz")
      instance.foo.should == "foovalue"
      instance.bar.should == instance.input_fields
    end

    it "should behave sensibly with both an optional field and input fields" do
      wrapper = Class.new(Clusta::Geometry::Element)
      wrapper.field :foo
      wrapper.field :bar, :optional => true
      
      instance = wrapper.new("foovalue", "barvalue", "extra1", "extra2")
      instance.foo.should == 'foovalue'
      instance.bar.should == 'barvalue'
      instance.input_fields.should == ['extra1', 'extra2']

      instance = wrapper.new("foovalue")
      instance.foo.should == 'foovalue'
      instance.bar.should be_nil
      instance.input_fields.should be_empty
      
    end
  end

  describe "embedded geometry elements" do

    before do
      @parent = Class.new(Clusta::Geometry::Element)
      
      @parent.field      :foo
      @parent.field      :child, :type => :geometry

      @child = Class.new(Clusta::Geometry::Element)
      @child.field :bar
      @child.field :baz

      # We have to do this manually b/c the class is not set to a
      # constant.
      @child.set_stream_name 'Child'
      Clusta::Geometry.register_element(@child, 'Child')
    end

    it "should be able to instantiate embedded elements when named as fields" do
      instance = @parent.new("foovalue", "Child;1;2")
      instance.foo.should == 'foovalue'
      instance.child.bar.should == '1'
      instance.child.baz.should == '2'
    end

    it "should be able to serialize embedded elements when named as fields" do
      instance = @parent.new('foovalue', @child.new('1', '2'))
      instance.to_flat.should include('foovalue', "Child;1;2")
    end

    it "should be able to instantiate embedded elements when given as input fields" do
      instance = @parent.new("foovalue", "Child;1;2", "Child;3;4")
      
      instance.foo.should == 'foovalue'
      
      instance.child.class.should == @child
      instance.child.bar.should == '1'
      instance.child.baz.should == '2'

      instance.input_fields.size.should == 1
      instance.input_fields[0].class.should == @child
      instance.input_fields[0].bar.should == '3'
      instance.input_fields[0].baz.should == '4'
    end

    it "should be able to serialize embedded elements when given as input fields" do
      instance = @parent.new('foovalue', @child.new('1','2'), @child.new('3','4'))
      instance.to_flat.should include('foovalue', "Child;1;2")
    end
    
  end

end

