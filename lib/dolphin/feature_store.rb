require 'fileutils'
require 'yaml'

module Dolphin
  module FeatureStore

    class << self

      def features
        YAML.load_file(feature_file) || {}
      rescue
        {}
      end

      def update_feature(feature, flipper)
        stored_features               = features
        stored_features[feature.to_s] = flipper.to_s

        save(stored_features)
      end
      
      def clear!
        save({})
      end

      def feature_directory
        @custom_feature_directory || rails_feature_directory
      end

      def feature_directory=(path)
        FileUtils.mkdir_p(path)
        @custom_feature_directory = path
      end

    private

      def save(updated_features)
        File.open(feature_file, 'w') do |f|
          YAML.dump(updated_features, f)
        end
      end

      def feature_file
        file = File.join(feature_directory, 'features.yml')
        FileUtils.touch(file) unless File.exist?(file)
        file
      end

      def rails_feature_directory
        path = File.join(Rails.root, 'config', 'dolphin')
        FileUtils.mkdir_p path
        path
      end

    end

  end
end
