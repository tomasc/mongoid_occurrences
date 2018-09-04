$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'bundler/setup'
require 'database_cleaner'
require 'minitest'
require 'minitest-implicit-subject'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/hooks/default'
require 'factory_bot'

require 'mongoid_occurrence_views'

Mongoid.configure do |config|
  config.connect_to('mongoid_occurrence_views_test')
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

DatabaseCleaner.orm = :mongoid
DatabaseCleaner.strategy = :truncation, {
  except: [
    Event.occurrences_ordering_view_name,
    Event.expanded_occurrences_view_name,
    EmbeddedEvent.occurrences_ordering_view_name,
    EmbeddedEvent.expanded_occurrences_view_name,
    EventParent.occurrences_ordering_view_name,
    EventParent.expanded_occurrences_view_name
  ]
}

[Event, EventParent, EmbeddedEvent].each do |klass|
  MongoidOccurrenceViews::DestroyMongodbView.call(name: klass.send(:occurrences_ordering_view_name))
  MongoidOccurrenceViews::DestroyMongodbView.call(name: klass.send(:expanded_occurrences_view_name))
  MongoidOccurrenceViews::Event::CreateOccurrencesOrderingView.call(klass)
  MongoidOccurrenceViews::Event::CreateExpandedOccurrencesView.call(klass)
end

class MiniTest::Spec
  include FactoryBot::Syntax::Methods
  FactoryBot.definition_file_paths = [File.expand_path('../factories', __FILE__)]
  FactoryBot.find_definitions
  before(:each) { DatabaseCleaner.clean }
end

Mongoid.logger.level = Logger::INFO
Mongo::Logger.logger.level = Logger::INFO
