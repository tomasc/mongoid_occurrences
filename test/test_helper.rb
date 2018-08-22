$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'bundler/setup'
require 'database_cleaner'
require 'minitest'
require 'minitest/autorun'
require 'minitest/spec'

require 'mongoid_occurrence_views'

Mongoid.configure do |config|
  config.connect_to('mongoid_occurrence_views_test')
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

DatabaseCleaner.orm = :mongoid
DatabaseCleaner.strategy = :truncation, {
  except: [DummyEvent.occurrences_view_name, DummyEvent.expanded_occurrences_view_name]
}

class MiniTest::Spec
  before(:each) { DatabaseCleaner.clean }
  after(:all) do
    MongoidOccurrenceViews::DestroyView.call(name: DummyEvent.occurrences_view_name)
    MongoidOccurrenceViews::DestroyView.call(name: DummyEvent.expanded_occurrences_view_name)
  end
end

Mongoid.logger.level = Logger::INFO
Mongo::Logger.logger.level = Logger::INFO
