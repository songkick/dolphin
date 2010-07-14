module Dolphin
  module Helper

    def feature(name, &block)
      return unless feature_available?(name)
      block.call if block_given?
    end

    def feature?(name)
      feature_available?(name)
    end

  private

    def feature_available?(name)
      feature_key = name.to_s
      return unless Dolphin.features[feature_key]

      rule_key = stored_features[feature_key] || Dolphin.features[feature_key]

      if Dolphin.rules[rule_key] && defined?(request)
        Dolphin.rules[rule_key].call(request)
      end

    rescue => e
      warn "[Dolphin] Error checking feature #{name} - #{e}"
      false
    end

    def stored_features
      @stored_features ||= FeatureStore.features
    end

  end
end
