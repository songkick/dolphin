module Dolphin
  class MissingRuleError < StandardError; end

  class DSL

    def initialize(feature_set, &block)
      @feature_set = feature_set
      instance_eval(&block)
    end

    def rule(name, &block)
      raise unless block_given?
      @feature_set.rules[name.to_s] = block
    end

    def feature(feature_name, rule_name)
      feature_name, rule_name = feature_name.to_s, rule_name.to_s

      unless @feature_set.rules[rule_name]
        raise MissingRuleError, "Feature '#{feature_name}' is using an undefined rule: #{rule_name}"
      end

      @feature_set.features[feature_name] = rule_name
    end

    def load_features_from(path)
      FeatureStore.custom_feature_path = path
    end

  end
end
