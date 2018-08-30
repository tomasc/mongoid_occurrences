class EventParent
  include Mongoid::Document

  include MongoidOccurrenceViews::Event::HasViewsOnOccurrences
  include MongoidOccurrenceViews::Event::HasOccurrenceScopes
  embeds_many :embedded_events, class_name: 'EmbeddedEvent'

  MongoidOccurrenceViews::Event::CreateOccurrencesOrderingView.call(EventParent)
  MongoidOccurrenceViews::Event::CreateExpandedOccurrencesView.call(EventParent)
end
