module MongoidOccurrences
  module Occurrence
    module HasDailyOccurrences
      def daily_occurrences
        adjust_dates_for_all_day!
        daily_occurrences_from_schedule + daily_occurrences_from_date_range
      end

      private

      def daily_occurrences_from_schedule
        return [] unless dtstart? && dtend?
        return [] unless recurring?
        schedule.occurrences(schedule_dtend).map do |occurrence|
          occurrence_dtstart = occurrence.start_time.in_time_zone(Time.zone).change(hour: dtstart.hour, minute: dtstart.minute)
          occurrence_dtend = occurrence.end_time.in_time_zone(Time.zone).change(hour: dtend.hour, minute: dtend.minute)

          build_daily_occurrence(occurrence_dtstart, occurrence_dtend, id, operator)
        end
      end

      def daily_occurrences_from_date_range
        return [] unless dtstart? && dtend?
        return [] if recurring?

        date_range = Range.new(dtstart.to_date, dtend.to_date)
        is_single_day = (date_range.first == date_range.last)

        date_range.map do |date|
          occurrence_dtstart = is_single_day || date == date_range.first ? dtstart : date.beginning_of_day
          occurrence_dtend = is_single_day || date == date_range.last ? dtend : date.end_of_day
          build_daily_occurrence(occurrence_dtstart, occurrence_dtend, id, operator)
        end
      end

      def build_daily_occurrence(dtstart, dtend, occurrence_id, operator)
        MongoidOccurrences::DailyOccurrence.new(dtstart: dtstart, dtend: dtend, occurrence_id: occurrence_id, operator: operator)
      end
    end
  end
end
