class Event
  include Mongoid::Document

  include MongoidOccurrenceViews::HasFieldsFromAggregation
  include MongoidOccurrenceViews::HasOccurrences

  embeds_many_occurrences class_name: "::Occurrence"
end
