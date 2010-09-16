require 'spec_helper'

describe Dolphin::FeatureStore do
  before do
    @store = Dolphin::FeatureStore
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

