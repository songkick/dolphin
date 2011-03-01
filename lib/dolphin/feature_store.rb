require 'fileutils'
require 'yaml'

module Dolphin
  module FeatureStore

    class << self

      def features
        path = feature_file
        
        if @last_read
          mtime = File.mtime(path)
          return @features if mtime.to_i <= @last_read.to_i
        end
        
        @last_read = Time.now
        @features  = YAML.load_file(path) || {}
      rescue
        warn "[Dolphin] Error loading features - #{e} - #{e.backtrace.inspect}"
        {}
      end

      def update_feature(feature, flipper)
        stored_features               = features
        stored_features[feature.to_s] = flipper.to_s

        save(stored_features)
      end
      
      def clear!
        @last_read = @features = nil
        save({})
      end

      def feature_directory
        @custom_feature_directory || rails_feature_directory
      end

      def feature_directory=(path)
        FileUtils.mkdir_p(path) if path
        @custom_feature_directory = path
        @last_read = @features = nil
      end

    private

      def save(updated_features)
        File.open(feature_file, 'w') do |f|
          f.sync = true
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
