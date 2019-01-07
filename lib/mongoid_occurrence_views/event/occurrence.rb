module MongoidOccurrenceViews
  module Event
    module Occurrence
      SCHEDULE_DURATION = 1.year

      def self.included(base)
        base.include MongoidOccurrenceViews::Event::HasOccurrenceScopes
        base.extend ClassMethods
      end

      module ClassMethods
        def embedded_in_event(options = {})
          field :dtstart, type: DateTime
          field :dtend, type: DateTime

          field :schedule, type: MongoidIceCubeExtension::Schedule
          field :schedule_dtend, type: Time

          embedded_in :event, class_name: options.fetch(:class_name, nil)
          embeds_many :daily_occurrences, class_name: 'MongoidOccurrenceViews::Event::Occurrence::DailyOccurrence', order: :dtstart.asc

          validates_presence_of :dtstart
          validates_presence_of :dtend

          before_validation :nil_schedule, unless: :recurring?

          after_validation :adjust_dates_for_all_day, if: :changed?
          after_validation :assign_daily_occurrences, if: :changed?
        end

        def dtstart_query_field
          :"daily_occurrences.ds"
        end

        def dtend_query_field
          :"daily_occurrences.de"
        end
      end

      def all_day
        return unless dtstart.present?
        return unless dtend.present?

        @all_day ||= dtstart == dtstart.beginning_of_day && dtend == dtend.end_of_day
      end
      alias all_day? all_day

      def all_day=(val)
        @all_day = [true, 'true', 1, '1'].include?(val)
      end

      def recurring?
        schedule.present?
      end

      def schedule_dtend
        read_attribute(:schedule_dtend) || (dtstart.try(:to_time) || Time.now) + SCHEDULE_DURATION
      end

      private

      def nil_schedule
        self.schedule = nil
      end

      def adjust_dates_for_all_day
        return unless all_day?

        self.dtstart = dtstart.beginning_of_day
        self.dtend = dtend.end_of_day
      end

      def assign_daily_occurrences
        self.daily_occurrences = daily_occurrences_from_schedule + daily_occurrences_from_date_range
      end

      def daily_occurrences_from_schedule
        return [] unless recurring?

        schedule.occurrences(schedule_dtend).map do |occurrence|
          relations['daily_occurrences'].klass.new(
            dtstart: occurrence.start_time,
            dtend: occurrence.end_time.change(hour: dtend.hour, min: dtend.minute)
          )
        end.compact
      end

      def daily_occurrences_from_date_range
        return [] if recurring?
        date_range = Range.new(dtstart.to_date, dtend.to_date)
        is_single_day = (date_range.first == date_range.last)

        date_range.map do |date|
          occurence_dtstart = is_single_day || date == date_range.first ? dtstart : date.beginning_of_day
          occurence_dtend = is_single_day || date == date_range.last ? dtend : date.end_of_day

          relations['daily_occurrences'].klass.new(
            dtstart: occurence_dtstart,
            dtend: occurence_dtend
          )
        end.compact
      end

      class DailyOccurrence
        include Mongoid::Document

        # alias fields to keep document size small
        field :ds, as: :dtstart, type: DateTime
        field :de, as: :dtend, type: DateTime

        def all_day
          return unless dtstart.present?
          return unless dtend.present?

          dtstart == dtstart.beginning_of_day && dtend == dtend.end_of_day
        end
        alias all_day? all_day
      end
    end
  end
end
