
module Dolphin
  class Experiment
    def initialize(name, logger=nil, &block)
      @name = name
      @logger = logger
      block.call(self)
      @comparison = lambda {|x| x }
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
    
    def compare_and_log_data_if(feature_name, &block)
      @log_comparison_failures = Dolphin.feature_available?(feature_name)
      @comparison = block if block
    end
    
    def run
      raise "must define existing implementation" unless @existing
      existing_result = @existing.call
      if Dolphin.feature_available?(@experimental_feature_name)
        begin
          experimental_result           = @experimental.call
          canonical_existing_result     = @comparison.call(existing_result)
          canonical_experimental_result = @comparison.call(experimental_result)
          if @logger and canonical_existing_result != canonical_experimental_result
            extra = nil
            if (@log_comparison_failures)
              extra = ", expected #{canonical_existing_result.inspect} got #{canonical_experimental_result.inspect}"
            end
            @logger.warn("#{@name}: experimental value differs#{extra}")
          end
          @use_experimental_result ? experimental_result : existing_result
        rescue Object => e
          if @use_experimental_result
            raise e
          else
            @logger.error(e)
            existing_result
          end
        end
      else
        existing_result
      end
    end
  end
end
