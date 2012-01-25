require 'spec_helper'

describe Dolphin::Experiment do

  before do
    Dolphin.stub!(:feature_available?).and_return(false)
  end
  
  it "should run existing if only that there" do
    result = Dolphin.experiment("foo") do |feature|
      feature.existing do
        101
      end
    end
    result.should == 101
  end

  it "should raise an error if only experimental defined" do
    lambda {
      Dolphin.experiment("foo") do |feature|
        feature.experimental(:sdf) do
          101
        end
      end
    }.should raise_error("must define existing implementation")
  end
  
  it "should swallow errors in the experimental block" do
    Dolphin.stub!(:feature_available?).with(:sdf).and_return(true)
    logger = stub("logger")
    logger.should_receive(:error)
    Dolphin.experiment("foo", logger) do |feature|
      feature.existing do
        101
      end
      feature.experimental(:sdf) do
        raise "hell"
      end
      feature.use_experimental_result?(:sdf)
    end.should == 101
  end
  
  it "should return existing implementation and not run experimental by default" do
    experimental_run = false
    result = Dolphin.experiment("foo") do |feature|
      feature.existing do
        101
      end
      
      feature.experimental(:experimental_feature) do
        experimental_run = true
        202
      end
    end
    result.should == 101
    experimental_run.should be_false
  end
  
  it "should run experimental if feature defined, but still return existing" do
    experimental_run = false
    Dolphin.stub!(:feature_available?).with(:experimental_feature).and_return(true)
    
    result = Dolphin.experiment("foo") do |feature|
      feature.existing do
        101
      end
      
      feature.experimental(:experimental_feature) do
        experimental_run = true
        202
      end
    end
    result.should == 101
    experimental_run.should be_true
  end
  
  it "should run experimental if feature defined, but still return existing, if the use experimental is not available" do
    experimental_run = false
    Dolphin.stub!(:feature_available?).with(:experimental_feature).and_return(true)
    
    result = Dolphin.experiment("foo") do |feature|
      feature.existing do
        101
      end
      
      feature.experimental(:experimental_feature) do
        experimental_run = true
        202
      end
      
      feature.use_experimental_result?(:experimental_feature_return)
    end
    result.should == 101
    experimental_run.should be_true
  end
  
  it "should run and return experimental if feature defined" do
    existing_run     = false
    experimental_run = false
    Dolphin.stub!(:feature_available?).with(:experimental_feature).and_return(true)
    Dolphin.stub!(:feature_available?).with(:experimental_feature_return).and_return(true)
    
    result = Dolphin.experiment("foo") do |feature|
      feature.existing do
        existing_run = true
        101
      end
      
      feature.experimental(:experimental_feature) do
        experimental_run = true
        202
      end
      
      feature.use_experimental_result?(:experimental_feature_return)
    end
    result.should == 202
    existing_run.should be_true
    experimental_run.should be_true
  end
  
  it "should compare the values and log if they are different" do
    Dolphin.stub!(:feature_available?).with(:experimental_feature).and_return(true)
    logger = stub("logger")
    logger.should_receive(:warn).with("foo: experimental value differs")
    Dolphin.experiment("foo", logger) do |feature|
      feature.existing do
        101
      end
      
      feature.experimental(:experimental_feature) do
        202
      end
    end
  end
  
  it "should not log if they are the same" do
    Dolphin.stub!(:feature_available?).with(:experimental_feature).and_return(true)
    logger = stub("logger")
    logger.should_not_receive(:warn)
    Dolphin.experiment("foo", logger) do |feature|
      feature.existing do
        101
      end
      
      feature.experimental(:experimental_feature) do
        101
      end
    end
  end
end
  



