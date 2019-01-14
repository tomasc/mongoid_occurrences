class Occurrence
  include Mongoid::Document
  include MongoidOccurrenceViews::Occurrence

  embedded_in_event class_name: '::Event'
end
