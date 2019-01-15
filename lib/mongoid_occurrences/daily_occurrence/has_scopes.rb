module MongoidOccurrences
  class DailyOccurrence
    module HasScopes
      def self.included(base)
        base.scope :occurs_between, ->(dtstart, dtend) { Queries::OccursBetween.criteria(criteria, dtstart, dtend) }
        base.scope :occurs_from, ->(dtstart) { Queries::OccursFrom.criteria(criteria, dtstart) }
        base.scope :occurs_on, ->(day) { Queries::OccursOn.criteria(criteria, day) }
        base.scope :occurs_until, ->(dtend) { Queries::OccursUntil.criteria(criteria, dtend) }
      end
    end
  end
end
