class DummyOccurrence
  include Mongoid::Document
  include MongoidOccurrenceViews::Occurrence
  embedded_in_event class_name: 'DummyEvent'
end

class DummyEvent
  include Mongoid::Document
  include MongoidOccurrenceViews::Event
  embeds_many_occurrences class_name: 'DummyOccurrence'
  # embedded_in :owner, class_name: 'DummyOwner'
end

class DummyOwner
  include Mongoid::Document
  include MongoidOccurrenceViews::HasOccurrenceViews
  embeds_many :events, class_name: 'DummyEvent'

  scope :for_date_time_range, ->(dtstart, dtend) {
    _dtstart = dtstart.beginning_of_day if dtstart.instance_of?(Date)
    _dtstart = dtstart.utc
    _dtend = dtend.end_of_day if dtend.instance_of?(Date)
    _dtend = dtend.utc
    lte(:_dtstart => dtend.to_datetime).gte(:_dtend => dtstart.to_datetime)
  }

  MongoidOccurrenceViews::CreateView.call(
      name: self.expanded_occurrences_view_name,
      collection: self.collection.name,
      pipeline: [
        { '$addFields': { '_events': '$events' } },
        { '$unwind': '$_events' },
        { '$unwind': '$_events.occurrences' },
        { '$unwind': '$_events.occurrences.daily_occurrences' },
        { '$addFields': {
          '_dtstart': '$_events.occurrences.daily_occurrences.ds',
          '_dtend': '$_events.occurrences.daily_occurrences.de',
          '_sort_key': '$_events.occurrences.daily_occurrences.ds'
        }
      }
    ]
  )
end
