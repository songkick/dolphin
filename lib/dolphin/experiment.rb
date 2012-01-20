
module Dolphin
  class Experiment
    def initialize(name, logger=nil, &block)
      @name = name
      @logger = logger
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
        begin
          experimental_result = @experimental.call
          if @logger and existing_result != experimental_result
            @logger.warn("#{@name}: experimental value differs, expected #{existing_result.inspect} got #{experimental_result.inspect}")
          end
          @use_experimental_result ? experimental_result : existing_result
        rescue Object => e
          @logger.error(e)
          existing_result
        end
      else
        existing_result
      end
    end
  end
end
