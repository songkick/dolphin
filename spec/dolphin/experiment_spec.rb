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
    Dolphin.stub!(:feature_available?).with(:exp).and_return(true)
    Dolphin.stub!(:feature_available?).with(:exposed).and_return(false)
    logger = stub("logger")
    logger.should_receive(:error)
    Dolphin.experiment("foo", logger) do |feature|
      feature.existing do
        101
      end
      feature.experimental(:exp) do
        raise "hell"
      end
      feature.use_experimental_result?(:exposed)
    end.should == 101
  end

  it "should not swallow errors in the experimental block if exposed" do
    Dolphin.stub!(:feature_available?).with(:exp).and_return(true)
    Dolphin.stub!(:feature_available?).with(:exposed).and_return(true)
    logger = stub("logger")
    logger.should_not_receive(:error)
    lambda {
      Dolphin.experiment("foo", logger) do |feature|
        feature.existing do
          101
        end
        feature.experimental(:exp) do
          raise "hell"
        end
        feature.use_experimental_result?(:exposed)
      end
    }.should raise_error("hell")
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
  
  describe "result comparison" do
    before do
      Dolphin.stub!(:feature_available?).with(:experimental_feature).and_return(true)
      @logger = stub("logger")
    end
    
    it "should compare the values and log if they are different" do
      @logger.should_receive(:warn).with("foo: experimental value differs")
      Dolphin.experiment("foo", @logger) do |feature|
        feature.existing do
          101
        end
        
        feature.experimental(:experimental_feature) do
          202
        end
      end
    end
    
    it "should not log if they are the same" do
      @logger.should_not_receive(:warn)
      Dolphin.experiment("foo", @logger) do |feature|
        feature.existing do
          101
        end
        
        feature.experimental(:experimental_feature) do
          101
        end
      end
    end
    
    it "can optionally log the values as well" do
      Dolphin.stub!(:feature_available?).with(:should_log_data_feature).and_return(true)
      @logger.should_receive(:warn).with("foo: experimental value differs, expected #{101} got #{202}")
      
      Dolphin.experiment("foo", @logger) do |feature|
        feature.existing do
          101
        end
        
        feature.experimental(:experimental_feature) do
          202
        end
        
        feature.compare_and_log_data_if(:should_log_data_feature)
      end
    end
    
    it "can optionally log the values as well, or not" do
      Dolphin.stub!(:feature_available?).with(:should_log_data_feature).and_return(false)
      @logger.should_receive(:warn).with("foo: experimental value differs")
      
      Dolphin.experiment("foo", @logger) do |feature|
        feature.existing do
          101
        end
        
        feature.experimental(:experimental_feature) do
          202
        end
        
        feature.compare_and_log_data_if(:should_log_data_feature)
      end
    end
    
    it "can use a transform block if one is provided" do
      @logger.should_receive(:warn).with("foo: experimental value differs")
      
      Dolphin.experiment("foo", @logger) do |feature|
        feature.existing do
          [3, 2, 1]
        end
        
        feature.experimental(:experimental_feature) do
          [1, 2, 3]
        end
        
        feature.compare_and_log_data_if(nil) do |obj|
          obj.sort
        end
      end
      
    end    
    
    it "can use a transform block if one is provided 2" do
      @logger.should_receive(:warn).with("foo: experimental value differs")
      
      Dolphin.experiment("foo", @logger) do |feature|
        feature.existing do
          [3, 2, 1]
        end
        
        feature.experimental(:experimental_feature) do
          [1, 2, 3]
        end
        
        feature.compare_and_log_data_if(nil) do |obj|
          obj
        end
      end
    end    
    
    it "can use a transform block if one is provided and log the differences" do
      Dolphin.stub!(:feature_available?).with(:should_log_data_feature).and_return(true)
      @logger.should_receive(:warn).with("foo: experimental value differs, expected [3, 2, 1] got [1, 2, 3]")
      
      Dolphin.experiment("foo", @logger) do |feature|
        feature.existing do
          [3, 2, 1]
        end
        
        feature.experimental(:experimental_feature) do
          [1, 2, 3]
        end
        
        feature.compare_and_log_data_if(:should_log_data_feature) do |obj|
          obj
        end
      end
      
    end    
  end
end    
  
  
  
