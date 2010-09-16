module Dolphin
  module Helper

    def feature(name, partial_options = {}, &block)
      return nil unless feature_available?(name)

      if partial_options[:partial] && respond_to?(:render)
        render partial_options
      elsif block_given?
        block.call
      end
    end

    def feature?(name)
      feature_available?(name)
    end

  private

    def feature_available?(name)
      return unless key = features[name.to_s]

      if flipper = Dolphin.flippers[key]
        instance_eval(&flipper)
      end

    rescue => e
      warn "[Dolphin] Error checking feature #{name}:#{key} - #{e}"
      false
    end

    def features
      @features ||= FeatureStore.features
    end

  end
end
