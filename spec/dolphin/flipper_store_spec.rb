require 'spec_helper'

describe Dolphin::FlipperStore do
  context "unconfigured" do
    it "should have only the default flippers" do
      Dolphin::FlipperStore.new.to_hash.should == Dolphin::FlipperStore.default_flippers
    end
    
    it "should let you retrieve flipper values" do
      block = Dolphin::FlipperStore.default_flippers["enabled"]
      Dolphin::FlipperStore.new["enabled"].should == block
      Dolphin::FlipperStore.new[:enabled].should == block
    end
  end
  
  describe "configuring" do
    before do
      @flippers = Dolphin::FlipperStore.new
    end
    
    it "should let you set flippers with the DSL" do
      block1, block2 = lambda { }, lambda {}
      
      Dolphin::FlipperStore::DSL.new(@flippers) do
        flipper(:foo, &block1)
        flipper("bar", &block2)
      end
      
      @flippers[:foo].should == block1
      @flippers["foo"].should == block1
      @flippers[:bar].should == block2
      @flippers["bar"].should == block2
    end
    
    it "should let you configure it twice" do
      block1, block2 = lambda { }, lambda {}
      
      Dolphin::FlipperStore::DSL.new(@flippers) do
        flipper(:foo, &block1)
      end
      Dolphin::FlipperStore::DSL.new(@flippers) do
        flipper("bar", &block2)
      end
      
      @flippers[:foo].should == block1
      @flippers["foo"].should == block1
      @flippers[:bar].should == block2
      @flippers["bar"].should == block2
    end
  end
end
