class EventParent
  include Mongoid::Document

  include MongoidOccurrenceViews::Event::HasViewsOnOccurrences
  include MongoidOccurrenceViews::Event::HasOccurrenceScopes
  embeds_many :embedded_events, class_name: 'EmbeddedEvent'

  MongoidOccurrenceViews::Event::CreateExpandedOccurrencesView.call(EventParent)
  # MongoidOccurrenceViews::Event::CreateOccurrencesOrderingView.call(EventParent)
end
