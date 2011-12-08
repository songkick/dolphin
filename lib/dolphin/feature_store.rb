module Dolphin
  
  # Encapsulates a mapping from feature name -> flipper name, stored in a YAML file.
  class FeatureStore
    def initialize(feature_file)
      @feature_file = File.expand_path(feature_file)
      if File.exist?(feature_file)
        if YAML.load_file(feature_file)
        else
          raise "dolphin feature file at #{feature_file} is not valid YAML"
        end
      else
        raise "missing dolphin feature file at #{feature_file}"
      end
    end
    
    attr_reader :feature_file
    
    def [](feature_name)
      features[feature_name.to_s]
    end
    
    def features
      if @last_read
        mtime = File.mtime(feature_file)
        return @features if mtime.to_i <= @last_read.to_i
      end
      
      @last_read = Time.now
      @features  = YAML.load_file(feature_file) || {}
    end

    def update_feature(feature, flipper)
      stored_features               = features
      stored_features[feature.to_s] = flipper.to_s

      save(stored_features)
    end
    
    def clear
      @last_read = @features = nil
      save({})
    end

    private

    def save(updated_features)
      File.open(feature_file, 'w') do |f|
        f.sync = true
        YAML.dump(updated_features, f)
      end
    end

  end
end
