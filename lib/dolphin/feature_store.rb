require 'fileutils'
require 'yaml'

module Dolphin
  module FeatureStore

    class << self

      def features
        YAML.load_file(file)['features'] rescue {}
      end

      def update_feature(feature, rule)
        stored_features               = features
        stored_features[feature.to_s] = rule.to_s

        save(stored_features)
      end

    protected

      def custom_feature_path=(path)
        FileUtils.mkdir_p(path)
        @custom_feature_path = path
      end

    private

      def save(updated_features)
        File.open(file, 'w') do |f|
          YAML.dump({'features' => updated_features}, f)
        end
      end

      def file
        File.join(path_prefix, 'feature_store.yml')
      end

      def path_prefix
        return rails_feature_path if rails?
        custom_feature_path
      end

      def rails?
        defined?(Rails) && Rails.respond_to?(:root)
      end

      def rails_feature_path
        path = File.join(Rails.root, 'config', 'dolphin')
        FileUtils.mkdir_p path
        path
      end

      def custom_feature_path
        @custom_feature_path
      end

    end

  end
end
