require 'spec_helper'

describe Dolphin::Helper do
  class ViewObject
    include Dolphin::Helper
    
    def render(*args)
    end
  end
  
  before do
    @helper_object = ViewObject.new
  end
  
  it "responds to :feature" do
    @helper_object.should respond_to(:feature)
  end
  
  describe "with a flipper" do
    before do
      Dolphin.configure {
        flipper(:true_flipper)  { true }
        flipper(:false_flipper) { false }
      }
    end
    
    describe "with an unrecognised feature" do
      it "does not run the block annotated by the feature" do
        Kernel.should_not_receive(:puts)
        @helper_object.feature(:unknown_feature) { Kernel.puts "hello" }
      end
      
      it "returns nil" do
        @helper_object.feature(:unknown_feature) { :hello }.should == nil
      end
    end
    
    describe "with a feature using the true flipper" do
      before do
        Dolphin::FeatureStore.update_feature(:true_feature, :true_flipper)
      end
      
      it "runs the block annotated by the feature" do
        Kernel.should_receive(:puts).once.with("hello")
        @helper_object.feature(:true_feature) { Kernel.puts "hello" }
      end
      
      it "returns the value of the block" do
        @helper_object.feature(:true_feature) { :hello }.should == :hello
      end
    end
    
    describe "with a feature using the false flipper" do
      before do
        Dolphin::FeatureStore.update_feature(:false_feature, :false_flipper)
      end
      
      it "does not run the block annotated by the feature" do
        Kernel.should_not_receive(:puts)
        @helper_object.feature(:false_feature) { Kernel.puts "hello" }
      end
      
      it "returns nil" do
        @helper_object.feature(:false_feature) { :hello }.should == nil
      end
    end
    
    describe "rendering a partial" do
      before do
        Dolphin::FeatureStore.update_feature(:true_feature, :true_flipper)
      end

      it "should call render passing through the options" do
        @helper_object.should_receive(:render).with(:partial => :qux, :foo => :bar)
        @helper_object.feature(:true_feature, :partial => :qux, :foo => :bar)
      end
    end
  end
end



