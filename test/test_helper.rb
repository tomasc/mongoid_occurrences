$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'bundler/setup'
require 'database_cleaner'
require 'minitest'
require 'minitest/autorun'
require 'minitest/spec'

require 'mongoid_occurrence_views'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Mongoid.configure do |config|
  config.connect_to('mongoid_occurrence_views_test')
end

DatabaseCleaner.orm = :mongoid
DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  before(:each) { DatabaseCleaner.clean }
end

Mongoid.logger.level = Logger::INFO
Mongo::Logger.logger.level = Logger::INFO
