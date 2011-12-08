require 'spec_helper'

describe Dolphin::FeatureStore do
  
  context "non existant feature file" do
    it "should raise an exception" do
      lambda {
        Dolphin::FeatureStore.new("/asldkfjadsklfj.txt")
      }.should raise_error("missing dolphin feature file at /asldkfjadsklfj.txt")
    end
  end
  
  context "existing empty feature file" do
    before do
      write_fixture_file("")
    end
    
    it "should raise an exception" do
      lambda {
        Dolphin::FeatureStore.new(fixture_path)
      }.should raise_error("dolphin feature file at #{fixture_path} is not valid YAML")
    end
  end
  
  context "existing feature file with features in" do
    before do
      write_fixture_file({"foo" => "enabled"}.to_yaml)
      @store = Dolphin::FeatureStore.new(fixture_path)
    end
    
    it "loads features from the file" do
      @store["foo"].should == "enabled"
      @store[:foo].should == "enabled"
    end
    
    it "changes features on disc when updated" do
      @store.update_feature(:foo, :qux)
      Dolphin::FeatureStore.new(fixture_path)["foo"].should == "qux"
      Dolphin::FeatureStore.new(fixture_path)[:foo].should == "qux"
    end
    
    it "should only read from disk once to get features" do
      YAML.should_receive(:load_file).once
      2.times { @store.features }
    end
    
    it "should read from disk again after the file is changed" do
      YAML.should_receive(:load_file).twice
      @store.features
      sleep 1
      @store.update_feature(:foo, :bar)
      2.times { @store.features }
    end
    
  end
end

