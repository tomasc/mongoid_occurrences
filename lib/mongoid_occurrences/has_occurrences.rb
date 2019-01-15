module MongoidOccurrences
  module HasOccurrences
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def embeds_many_occurrences(options = {})
        field :_previous_occurrences_cache_key, type: String

        embeds_many :occurrences, class_name: options.fetch(:class_name)
        accepts_nested_attributes_for :occurrences, allow_destroy: true, reject_if: :all_blank

        embeds_many :daily_occurrences, class_name: 'MongoidOccurrences::DailyOccurrence', order: :dtstart.asc

        after_validation :assign_occurrences_cache_key!
        after_validation :assign_daily_occurrences!, if: :_previous_occurrences_cache_key_changed?

        scope :occurs_between, ->(dtstart, dtend) { elem_match(daily_occurrences: DailyOccurrence.occurs_between(dtstart, dtend).selector) }
        scope :occurs_from, ->(dtstart) { elem_match(daily_occurrences: DailyOccurrence.occurs_from(dtstart).selector) }
        scope :occurs_on, ->(day) { elem_match(daily_occurrences: DailyOccurrence.occurs_on(day).selector) }
        scope :occurs_until, ->(dtend) { elem_match(daily_occurrences: DailyOccurrence.occurs_until(dtend).selector) }
      end
    end

    def occurrences_cache_key
      last_timestamp = occurrences.unscoped.order(updated_at: :desc).limit(1).pluck(:updated_at).first
      "#{occurrences.unscoped.size}-#{last_timestamp.to_i}"
    end

    def assign_daily_occurrences!
      self.daily_occurrences = begin
        res = occurrences.with_operators(:append).flat_map(&:daily_occurrences)

        occurrences.with_operators(%i[remove replace]).flat_map(&:daily_occurrences).each do |occurrence|
          res = res.reject { |res_occurrence| res_occurrence.overlaps?(occurrence) }
        end

        res += occurrences.with_operators(%i[replace]).flat_map(&:daily_occurrences)

        res.sort
      end
    end

    private

    def assign_occurrences_cache_key!
      self._previous_occurrences_cache_key = occurrences_cache_key
    end
  end
end
