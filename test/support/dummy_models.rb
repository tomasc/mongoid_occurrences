class DummyOccurrence
  include Mongoid::Document
  include MongoidOccurrenceViews::Occurrence
  embedded_in_event class_name: 'DummyEvent'
end

class DummyEvent
  include Mongoid::Document
  include MongoidOccurrenceViews::Event
  embeds_many_occurrences class_name: 'DummyOccurrence'
end
