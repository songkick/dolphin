require 'spec_helper'

describe Dolphin do
  before do
    Dolphin.init(File.expand_path("../fixtures/example_features.yml", __FILE__))
    
    Dolphin.configure do
      flipper(:custom) { $dolphin_test_value == true }
    end
  end
  
  it "should run flippers to see which features are on" do
    Dolphin.feature_available?(:on_feature).should == true
    Dolphin.feature_available?("on_feature").should == true
    
    Dolphin.feature_available?(:off_feature).should == false
    Dolphin.feature_available?("off_feature").should == false

    $dolphin_test_value = true
    Dolphin.feature_available?(:feature_with_a_custom_flipper).should == true
    Dolphin.feature_available?("feature_with_a_custom_flipper").should == true

    $dolphin_test_value = false
    Dolphin.feature_available?(:feature_with_a_custom_flipper).should == false
    Dolphin.feature_available?("feature_with_a_custom_flipper").should == false
  end

  it "should say features with undefined flippers are off" do
    Dolphin.feature_available?(:feature_without_a_flipper).should == false
    Dolphin.feature_available?("feature_without_a_flipper").should == false    
  end

  it "says features it doesn't know about are off" do
    Dolphin.feature_available?(:nonexistant_feature).should == false
    Dolphin.feature_available?("nonexistant_feature").should == false
  end
  
  it "raises a helpful exception if it has not been initialized" do
    Dolphin.clear
    lambda {
      Dolphin.feature_available?(:adsf)
    }.should raise_error("Dolphin has not been initialized with a features file")
  end
  
  it "says all features are off if the file doesn't exist" do
    Dolphin.init("/asdfasdfadsf")
    Dolphin.feature_available?(:adsf).should be_false
  end

  context "with a custom feature store" do
    let(:feature_store) { mock(:feature_store, :'[]' => 'enabled') }

    before do
      Dolphin.init_with_store(feature_store)
    end

    it "should call the custom feature store" do
      feature_store.should_receive(:'[]').with('my_feature').and_return('enabled')
      Dolphin.feature_available?('my_feature')
    end
  end
end
