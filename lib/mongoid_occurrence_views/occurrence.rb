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

        embeds_many :daily_occurrences, class_name: 'MongoidOccurrenceViews::Occurrence::DailyOccurrence', order: :dtstart.asc

        validates_presence_of :dtstart
        validates_presence_of :dtend

        before_validation :set_daily_occurrences
      end
    end

    def schedule_dtend
      dtstart + 1.year
    end

    def recurring?
      schedule.present?
    end

    def spans_days?
      date_range.first != date_range.last
    end

    private

    def set_daily_occurrences
      set_daily_occurrences_from_schedule
      set_daily_occurrences_from_date_range
    end

    def set_daily_occurrences_from_schedule
      return unless recurring?

      schedule.occurrences(schedule_dtend).collect do |occurrence|
        occurrence_dtstart = occurrence.start_time
        occurrence_dtend = occurrence.end_time.change(hour: self.dtend.hour, min: self.dtend.minute)
        daily_occurrences.build(dtstart: occurrence_dtstart, dtend: occurrence_dtend, all_day: all_day)
      end
    end

    def set_daily_occurrences_from_date_range
      return if recurring?

      date_range.each_with_index.each do |date, index|
        case
        when all_day?
          occurence_dtstart = date.beginning_of_day
          occurence_dtend = date.end_of_day
        when !spans_days?
          occurence_dtstart = dtstart
          occurence_dtend = dtend
        when date == date_range.first
          occurence_dtstart = dtstart
          occurence_dtend = date.end_of_day
        when date == date_range.last
          occurence_dtstart = date.beginning_of_day
          occurence_dtend = dtend
        else
          occurence_dtstart = date.beginning_of_day
          occurence_dtend = date.end_of_day
        end
        daily_occurrences.build(dtstart: occurence_dtstart, dtend: occurence_dtend, all_day: all_day)
      end
    end

    def date_range
      Range.new(dtstart.to_date, dtend.to_date)
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
