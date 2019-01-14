module MongoidOccurrenceViews
  module Occurrence
    module HasScopes
      def self.included(base)
        base.scope :occurs_between, ->(dtstart, dtend) { elem_match(daily_occurrences: DailyOccurrence.occurs_between(dtstart, dtend).selector) }
        base.scope :occurs_from, ->(dtstart) { elem_match(daily_occurrences: DailyOccurrence.occurs_from(dtstart).selector) }
        base.scope :occurs_on, ->(day) { elem_match(daily_occurrences: DailyOccurrence.occurs_on(day).selector) }
        base.scope :occurs_until, ->(dtend) { elem_match(daily_occurrences: DailyOccurrence.occurs_until(dtend).selector) }
      end
    end
  end
end
