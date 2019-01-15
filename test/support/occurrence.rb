class Occurrence
  include Mongoid::Document
  include MongoidOccurrences::Occurrence

  embedded_in_event class_name: '::Event'
end
