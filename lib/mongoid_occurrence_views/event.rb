module MongoidOccurrenceViews
  module Event
    def self.included(base)
      base.class_eval do
        include HasViewsOnOccurrences
      end
      base.extend ClassMethods
    end

    module ClassMethods
      def embeds_many_occurrences(options = {})
        embeds_many :occurrences, class_name: options.fetch(:class_name)
        accepts_nested_attributes_for :occurrences, allow_destroy: true

        scope :occurs_on, -> (date_time, dtstart_field = :_dtstart, dtend_field = :_dtend) { MongoidOccurrenceViews::Queries::OccursOn.criteria(criteria, date_time, dtstart_field: dtstart_field, dtend_field: dtend_field) }
        scope :occurs_between, ->(dtstart, dtend, dtstart_field = :_dtstart, dtend_field = :_dtend) { MongoidOccurrenceViews::Queries::OccursBetween.criteria(self, dtstart, dtend, dtstart_field: dtstart_field, dtend_field: dtend_field) }
        scope :occurs_from, ->(date_time, dtstart_field = :_dtstart) { MongoidOccurrenceViews::Queries::OccursFrom.criteria(self, date_time, dtstart_field: dtstart_field) }
        scope :occurs_until, ->(date_time, dtend_field = :_dtend) { MongoidOccurrenceViews::Queries::OccursUntil.criteria(self, date_time, dtstart_field: dtstart_field) }

        scope :order_by_start, ->(order = :asc) { MongoidOccurrenceViews::Queries::OrderByStart.criteria(self, order) }
        scope :order_by_end, ->(order = :asc) { MongoidOccurrenceViews::Queries::OrderByEnd.criteria(self, order) }

        CreateOccurrencesOrderingView.call(self)
        CreateExpandedOccurrencesView.call(self)
      end
    end
  end
end
