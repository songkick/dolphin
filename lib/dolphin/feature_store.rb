module Dolphin
  
  # Encapsulates a mapping from feature name -> flipper name, stored in a YAML file.
  class FeatureStore
    def initialize(feature_file)
      @feature_file = File.expand_path(feature_file)
      @features     = read_file
    end
    
    attr_reader :feature_file
    
    def [](feature_name)
      features[feature_name.to_s]
    end
    
    def features
      unless file_updated?
        return @features
      end
      
      @features = read_file
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
    
    def read_file
      @last_read = Time.now
      if File.exist?(feature_file)
        YAML.load_file(feature_file)
      else
        {}
      end
    end
    
    def file_updated?
      if @last_read
        if File.exist?(feature_file)
          File.mtime(feature_file).to_i > @last_read.to_i
        else
          false
        end
      else
        true
      end
    end

    def save(updated_features)
      File.open(feature_file, 'w') do |f|
        f.sync = true
        YAML.dump(updated_features, f)
      end
    end

  end
end
