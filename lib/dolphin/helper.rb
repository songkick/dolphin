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
      return unless key = features[name.to_s]

      if Dolphin.flippers[key] && defined?(request)
        Dolphin.flippers[key].call(request)
      end

    rescue => e
      warn "[Dolphin] Error checking feature #{name} - #{e}"
      false
    end

    def features
      @features ||= FeatureStore.features
    end

  end
end
