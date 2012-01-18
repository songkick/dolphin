
module Dolphin
  class Experiment
    def initialize(name, &block)
      @name = name
      block.call(self)
    end
    
    def existing(&block)
      @existing = block
    end
    
    def experimental(feature_name, &block)
      @experimental_feature_name = feature_name
      @experimental = block
    end
    
    def use_experimental_result?(feature_name)
      @use_experimental_result = Dolphin.feature_available?(feature_name)
    end
    
    def run
      raise "must define existing implementation" unless @existing
      existing_result = @existing.call
      if Dolphin.feature_available?(@experimental_feature_name)
        experimental_result = @experimental.call
        @use_experimental_result ? experimental_result : existing_result
      else
        existing_result
      end
    end
  end
end
