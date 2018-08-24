module MongoidOccurrenceViews
  module Event
    module Occurrence
      SCHEDULE_DURATION = 1.year

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def embedded_in_event(options = {})
          field :dtstart, type: DateTime
          field :dtend, type: DateTime

          field :schedule, type: MongoidIceCubeExtension::Schedule

          embedded_in :event, class_name: options.fetch(:class_name, nil)
          embeds_many :daily_occurrences, class_name: 'MongoidOccurrenceViews::Event::Occurrence::DailyOccurrence', order: :dtstart.asc

          validates_presence_of :dtstart
          validates_presence_of :dtend

          before_validation :adjust_dates_for_all_day
          before_validation :set_daily_occurrences
        end
      end

      def all_day
        @all_day ||= begin
          dtstart == dtstart.beginning_of_day &&
            dtend == dtend.end_of_day
        end
      end
      alias all_day? all_day

      def all_day=(val)
        @all_day = val
      end

      def schedule_dtend
        dtstart + SCHEDULE_DURATION
      end

      def recurring?
        schedule.present?
      end

      private

      def adjust_dates_for_all_day
        return unless all_day?

        self.dtstart = dtstart.beginning_of_day
        self.dtend = dtend.end_of_day
      end

      def set_daily_occurrences
        set_daily_occurrences_from_schedule
        set_daily_occurrences_from_date_range
      end

      def set_daily_occurrences_from_schedule
        return unless recurring?

        schedule.occurrences(schedule_dtend.to_time).each do |occurrence|
          daily_occurrences.build(
            dtstart: occurrence.start_time,
            dtend: occurrence.end_time.change(hour: dtend.hour, min: dtend.minute)
          )
        end
      end

      def set_daily_occurrences_from_date_range
        return if recurring?

        date_range = Range.new(dtstart.to_date, dtend.to_date)
        is_single_day = (date_range.first == date_range.last)

        date_range.each do |date|
          occurence_dtstart = is_single_day || date == date_range.first ? dtstart : date.beginning_of_day
          occurence_dtend = is_single_day || date == date_range.last ? dtend : date.end_of_day

          daily_occurrences.build(dtstart: occurence_dtstart, dtend: occurence_dtend)
        end
      end

      class DailyOccurrence
        include Mongoid::Document

        # alias fields to keep document size small
        field :ds, as: :dtstart, type: DateTime
        field :de, as: :dtend, type: DateTime
      end
    end
  end
end
