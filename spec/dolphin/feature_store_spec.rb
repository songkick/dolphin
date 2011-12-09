require 'spec_helper'

describe Dolphin::FeatureStore do
  
  context "non existant feature file" do
    it "should not raise an exception" do
      store = Dolphin::FeatureStore.new(fixture_path + ".foo")
      store.features
    end
    
    it "should not raise an exception if you ask again" do
      store = Dolphin::FeatureStore.new(fixture_path + ".foo")
      store.features
      store.features
    end
    
    it "should reload if you then create the file" do
      store = Dolphin::FeatureStore.new(fixture_path + ".foo")
      store["foo"].should be_nil
      store.update_feature(:foo, :enabled)
      store["foo"].should == "enabled"
      FileUtils.rm(fixture_path + ".foo")
    end
  end
  
  context "existing feature file with features in" do
    before do
      write_fixture_file({"foo" => "enabled"}.to_yaml)
    end
    
    it "loads features from the file" do
      store = Dolphin::FeatureStore.new(fixture_path)
      store["foo"].should == "enabled"
      store[:foo].should == "enabled"
    end
    
    it "changes features on disc when updated" do
      store = Dolphin::FeatureStore.new(fixture_path)
      store.update_feature(:foo, :qux)
      Dolphin::FeatureStore.new(fixture_path)["foo"].should == "qux"
      Dolphin::FeatureStore.new(fixture_path)[:foo].should == "qux"
    end
    
    it "should only read from disk once to get features" do
      YAML.should_receive(:load_file).once.and_return({"foo" => "enabled"})
      store = Dolphin::FeatureStore.new(fixture_path)
      store.features
    end
    
    it "should read from disk again after the file is changed" do
      store = Dolphin::FeatureStore.new(fixture_path)
      YAML.should_receive(:load_file).once.and_return({"foo" => "enabled"})
      store.features
      sleep 1
      store.update_feature(:foo, :bar)
      2.times { store.features }
    end
    
  end
end

