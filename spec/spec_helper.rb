dir = File.expand_path(File.dirname(__FILE__))

require dir + '/../lib/dolphin'
Dolphin::FeatureStore.feature_directory = dir + '/config'

Spec::Runner.configure do |config|
  config.after { Dolphin.clear! }
end

