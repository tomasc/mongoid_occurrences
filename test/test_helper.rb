$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'bundler/setup'
require 'database_cleaner'
require 'minitest'
require 'minitest-implicit-subject'
require 'minitest/autorun'
require 'minitest/spec'
require 'factory_bot'

require 'active_support/core_ext/date'
require 'active_support/core_ext/date_time'
require 'active_support/core_ext/time'

require 'mongoid_occurrences'

Time.zone = 'Hawaii'

Mongoid.configure do |config|
  config.connect_to('mongoid_occurrences__test')
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

DatabaseCleaner.orm = :mongoid
DatabaseCleaner.strategy = :truncation

class Minitest::Spec
  include FactoryBot::Syntax::Methods
  FactoryBot.definition_file_paths = [File.expand_path('../factories', __FILE__)]
  FactoryBot.find_definitions
  before(:each) { DatabaseCleaner.clean }
end

Mongoid.logger.level = Logger::INFO
Mongo::Logger.logger.level = Logger::INFO
