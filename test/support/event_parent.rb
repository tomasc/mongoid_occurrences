class EventParent
  include Mongoid::Document
  include MongoidOccurrenceViews::Event::HasViewsOnOccurrences

  embeds_many :embedded_events, class_name: 'EmbeddedEvent'

  MongoidOccurrenceViews::Event::CreateOccurrencesView.call(EventParent)
  MongoidOccurrenceViews::Event::CreateExpandedOccurrencesView.call(EventParent)
end
