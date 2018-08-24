class EmbeddedEvent
  include Mongoid::Document
  include MongoidOccurrenceViews::Event

  embeds_many_occurrences class_name: 'Occurrence'
  embedded_in :owner, class_name: 'EventParent'
end
