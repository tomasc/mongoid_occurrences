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
  except: [
    Event.occurrences_view_name,
    Event.expanded_occurrences_view_name,

    EmbeddedEvent.occurrences_view_name,
    EmbeddedEvent.expanded_occurrences_view_name,

    EventParent.occurrences_view_name,
    EventParent.expanded_occurrences_view_name
  ]
}

class MiniTest::Spec
  before(:each) { DatabaseCleaner.clean }
  # after(:all) do
  #   MongoidOccurrenceViews::DestroyMongoidView.call(name: Event.occurrences_view_name)
  #   MongoidOccurrenceViews::DestroyMongoidView.call(name: Event.expanded_occurrences_view_name)
  #   MongoidOccurrenceViews::DestroyMongoidView.call(name: EventParent.occurrences_view_name)
  #   MongoidOccurrenceViews::DestroyMongoidView.call(name: EventParent.expanded_occurrences_view_name)
  #   MongoidOccurrenceViews::Event::CreateOccurrencesView.call(Event)
  #   MongoidOccurrenceViews::CreateExpandedOccurrencesView.call(Event)
  #   MongoidOccurrenceViews::CreateExpandedOccurrencesView.call(EventParent)
  # end
end

Mongoid.logger.level = Logger::INFO
Mongo::Logger.logger.level = Logger::INFO
