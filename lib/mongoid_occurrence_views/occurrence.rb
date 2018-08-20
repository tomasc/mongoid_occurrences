module MongoidOccurrenceViews
  module Occurrence
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def embedded_in_event(options = {})
        field :dtstart, type: DateTime
        field :dtend, type: DateTime
        field :all_day, type: Boolean, default: false

        field :schedule, type: MongoidIceCubeExtension::Schedule
        field :occurrences, type: Array

        embeds_many :daily_occurrences, class_name: 'MongoidOccurrenceViews::Occurrence::DailyOccurrence', order: :dtstart.asc

        validates_presence_of :dtstart
        validates_presence_of :dtend

        before_validation :set_daily_occurrences
      end
    end

    # keep this separate so it can be read and/or overridden
    def schedule_dtend
      dtstart + 1.year
    end

    def recurring?
      schedule.present?
    end

    private

    def set_daily_occurrences
      set_daily_occurrences_from_schedule
      set_daily_occurrences_from_datetime_range
    end

    def set_daily_occurrences_from_schedule
      return unless recurring?

      schedule.occurrences(schedule_dtend).collect do |occurrence|
        occurrence_dtstart = occurrence.start_time
        occurrence_dtend = occurrence.end_time
        occurrence_dtend = occurrence.end_time.change(hour: self.dtend.hour, min: self.dtend.minute)
        daily_occurrences.build(dtstart: occurrence_dtstart, dtend: occurrence_dtend, all_day: all_day)
      end
    end

    def set_daily_occurrences_from_datetime_range
      return if recurring?

      Range.new(dtstart.to_date, dtend.to_date).each_with_index.map do |date, index|
        occurence_dtstart = dtstart + index.days
        occurence_dtend = occurence_dtstart.change(hour: dtend.hour, min: dtend.min, sec: dtend.sec)
        daily_occurrences.build(dtstart: occurence_dtstart, dtend: occurence_dtend, all_day: all_day)
      end
    end

    class DailyOccurrence
      include Mongoid::Document

      # alias fields to keep document size small
      field :ds, as: :dtstart, type: DateTime
      field :de, as: :dtend, type: DateTime
      field :ad, as: :all_day, type: Boolean
    end
  end
end
