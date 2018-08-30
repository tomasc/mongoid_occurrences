class Event
  include Mongoid::Document

  include MongoidOccurrenceViews::Event
  embeds_many_occurrences class_name: 'Occurrence'
end
