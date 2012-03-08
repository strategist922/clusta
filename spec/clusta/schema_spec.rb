require 'spec_helper'

describe Clusta::Schema do

  before do
    @root = Class.new
    @root.send(:include, Clusta::Schema)
  end

  it "should not define any fields of its own" do
    @root.fields.should == []
  end

  it "should allow a subclass to set its own fields without polluting the parent" do
    subclass = Class.new(@root)
    subclass.key :foo
    @root.field_names.should_not include('foo')
    subclass.field_names.should include('foo')
  end

  it "should allow a subclass of a subclass to set its own fields without polluting the parent" do
    subclass1 = Class.new(@root)
    subclass1.key :foo
    subclass2 = Class.new(subclass1)
    subclass2.key :bar
    
    @root.field_names.should_not include('foo')
    @root.field_names.should_not include('bar')
    
    subclass1.field_names.should include('foo')
    subclass1.field_names.should_not include('bar')

    subclass2.field_names.should include('foo')
    subclass2.field_names.should include('bar')
  end
end
