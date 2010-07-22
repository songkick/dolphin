ENV["RAILS_ENV"] = "test"

require File.expand_path('../../test_app/config/environment', File.dirname(__FILE__))

require 'cucumber/rails/world'
require 'cucumber/formatter/unicode'

Cucumber::Rails::World.use_transactional_fixtures = true

require 'capybara/rails'
require 'capybara/cucumber'
require 'capybara/session'
require 'cucumber/rails/capybara_javascript_emulation'

Capybara.default_selector = :css
ActionController::Base.allow_rescue = false

require File.expand_path('silences_errors', File.dirname(__FILE__))
World(SilencesErrors)

Before('@silence') do
  silence_stderr
end

After('@silence') do
  restore_stderr
end
