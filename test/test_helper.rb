# Configure Rails Envinronment
ENV['RAILS_ENV'] = 'test'
RUBYOPT="-w $RUBYOPT"

if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.adapters.define 'rubygem' do
    # Add app to Merit group
    # https://github.com/colszowka/simplecov/pull/104
    add_group 'Merit', 'lib'
    add_group 'DummyApp', 'test/dummy'
    add_filter 'test/dummy/config/initializers'
  end
  SimpleCov.start 'rubygem'
end


require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rails/test_help'
require 'minitest/rails'

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require 'capybara/rails'
Capybara.default_driver   = :rack_test
Capybara.default_selector = :css

Merit.orm = :mongoid if Merit.orm.nil?

def mongoid_orm?
  Merit.orm == :mongoid
end

require "orm/mongoid"

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
