class Occurrence
  include Mongoid::Document

  include MongoidOccurrenceViews::Event::Occurrence
  embedded_in_event class_name: 'Event'
end
