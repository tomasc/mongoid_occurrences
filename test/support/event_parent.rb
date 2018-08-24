class EventParent
  include Mongoid::Document
  include MongoidOccurrenceViews::Event::HasViewsOnOccurrences

  embeds_many :embedded_events, class_name: 'EmbeddedEvent'

  # scope :for_date_time_range, ->(dtstart, dtend) {
  #   _dtstart = dtstart.beginning_of_day if dtstart.instance_of?(Date)
  #   _dtstart = dtstart.utc
  #   _dtend = dtend.end_of_day if dtend.instance_of?(Date)
  #   _dtend = dtend.utc
  #   lte(:_dtstart => dtend.to_datetime).gte(:_dtend => dtstart.to_datetime)
  # }
  #
  # # NOTE: this stuff below should be automatico, right?
  # MongoidOccurrenceViews::CreateMongoidView.call(
  #     name: expanded_occurrences_view_name,
  #     collection: collection.name,
  #     pipeline: [
  #       { '$addFields': { '_events': '$events' } },
  #       { '$unwind': '$_events' },
  #       { '$unwind': '$_events.occurrences' },
  #       { '$unwind': '$_events.occurrences.daily_occurrences' },
  #       { '$addFields': {
  #         '_dtstart': '$_events.occurrences.daily_occurrences.ds',
  #         '_dtend': '$_events.occurrences.daily_occurrences.de',
  #         '_sort_key': '$_events.occurrences.daily_occurrences.ds'
  #       }
  #     }
  #   ]
  # )
end
