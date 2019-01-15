module MongoidOccurrences
  module Occurrence
    module HasDailyOccurrences
      def daily_occurrences
        adjust_dates_for_all_day!

        daily_occurrences_from_schedule +
          daily_occurrences_from_date_range
      end

      private

      def daily_occurrences_from_schedule
        return [] unless dtstart? && dtend?
        return [] unless recurring?

        schedule.occurrences(schedule_dtend).map do |occurrence|
          MongoidOccurrences::DailyOccurrence.new(
            dtstart: occurrence.start_time.change(hour: dtstart.hour, min: dtstart.minute),
            dtend: occurrence.end_time.change(hour: dtend.hour, min: dtend.minute),
            operator: operator
          )
        end
      end

      def daily_occurrences_from_date_range
        return [] unless dtstart? && dtend?
        return [] if recurring?

        date_range = Range.new(dtstart.to_date, dtend.to_date)
        is_single_day = (date_range.first == date_range.last)

        date_range.map do |date|
          occurence_dtstart = is_single_day || date == date_range.first ? dtstart : date.beginning_of_day
          occurence_dtend = is_single_day || date == date_range.last ? dtend : date.end_of_day

          MongoidOccurrences::DailyOccurrence.new(
            dtstart: occurence_dtstart,
            dtend: occurence_dtend,
            operator: operator
          )
        end
      end
    end
  end
end
