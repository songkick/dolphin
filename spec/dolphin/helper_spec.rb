require 'spec_helper'

describe Dolphin::Helper do
  before do
    @helper_class  = Class.new { include Dolphin::Helper }
    @helper_object = @helper_class.new
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
    
    it "raises an error for an unknown feature" do
      lambda { @helper_object.feature(:unknown) {  } }.should raise_error(Dolphin::ConfigurationError)
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
  end
end

