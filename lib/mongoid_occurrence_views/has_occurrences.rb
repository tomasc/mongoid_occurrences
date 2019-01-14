module MongoidOccurrenceViews
  module HasOccurrences
    def self.included(base)
      base.extend ClassMethods

      base.scope :occurs_between, ->(dtstart, dtend) { elem_match(daily_occurrences: DailyOccurrence.occurs_between(dtstart, dtend).selector) }
      base.scope :occurs_from, ->(dtstart) { elem_match(daily_occurrences: DailyOccurrence.occurs_from(dtstart).selector) }
      base.scope :occurs_on, ->(day) { elem_match(daily_occurrences: DailyOccurrence.occurs_on(day).selector) }
      base.scope :occurs_until, ->(dtend) { elem_match(daily_occurrences: DailyOccurrence.occurs_until(dtend).selector) }
    end

    module ClassMethods
      def embeds_many_occurrences(options = {})
        embeds_many :occurrences, class_name: options.fetch(:class_name)
        accepts_nested_attributes_for :occurrences, allow_destroy: true, reject_if: :all_blank

        embeds_many :daily_occurrences, class_name: 'MongoidOccurrenceViews::DailyOccurrence', order: :dtstart.asc

        after_validation :assign_daily_occurrences!
      end
    end

    def assign_daily_occurrences!
      self.daily_occurrences = occurrences.flat_map(&:daily_occurrences)
    end
  end
end
