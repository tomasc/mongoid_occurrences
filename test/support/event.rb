class Event
  include Mongoid::Document

  include MongoidOccurrences::HasFieldsFromAggregation
  include MongoidOccurrences::HasOccurrences

  embeds_many_occurrences class_name: 'Occurrence'
end
