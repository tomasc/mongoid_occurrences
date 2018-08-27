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

        scope :for_date_time, -> (date_time) { MongoidOccurrenceViews::Queries::DateTime.criteria(self, date_time) }
        scope :for_date_time_range, ->(dtstart, dtend) { MongoidOccurrenceViews::Queries::DateTimeRange.criteria(self, dtstart, dtend) }
        scope :from_date_time, ->(date_time) { MongoidOccurrenceViews::Queries::FromDateTime.criteria(self, date_time) }
        scope :to_date_time, ->(date_time) { MongoidOccurrenceViews::Queries::ToDateTime.criteria(self, date_time) }

        scope :order_by_start, ->(order = :asc) { MongoidOccurrenceViews::Queries::OrderByStart.criteria(self, order) }
        scope :order_by_end, ->(order = :asc) { MongoidOccurrenceViews::Queries::OrderByEnd.criteria(self, order) }

        CreateOccurrencesOrderingView.call(self)
        CreateExpandedOccurrencesView.call(self)
      end
    end
  end
end
