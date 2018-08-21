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

    def date_range
      Range.new(dtstart.to_date, dtend.to_date)
    end

    def set_daily_occurrences
      set_daily_occurrences_from_schedule
      set_daily_occurrences_from_date_range
    end

    def set_daily_occurrences_from_schedule
      return unless recurring?

      schedule.occurrences(schedule_dtend.to_time).collect do |occurrence|
        daily_occurrences.build(
          dtstart: occurrence.start_time,
          dtend: occurrence.end_time.change(hour: dtend.hour, min: dtend.minute),
          all_day: all_day
        )
      end
    end

    def set_daily_occurrences_from_date_range
      return if recurring?

      date_range.each_with_index.each do |date, index|
        occurence_dtstart = case
                            when all_day? then date.beginning_of_day
                            when spans_days? then date == date_range.first ? dtstart : date.beginning_of_day
                            else dtstart
                            end

        occurence_dtend =   case
                            when all_day? then date.end_of_day
                            when spans_days? then date == date_range.last ? dtend : date.end_of_day
                            else dtend
                            end

        daily_occurrences.build(
          dtstart: occurence_dtstart,
          dtend: occurence_dtend,
          all_day: all_day
        )
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
