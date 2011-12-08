$:.unshift File.expand_path("../../lib", __FILE__)
require 'dolphin'

def write_fixture_file(content)
  File.open(fixture_path, "w") {|f| f.puts(content) }
end

def fixture_path
  File.expand_path("../fixtures/tmp_features.yml", __FILE__)
end

Spec::Runner.configure do |config|
  config.before {  }
  config.after  { Dolphin.clear }
end

