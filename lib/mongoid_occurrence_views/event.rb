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

        scope :occurs_between, ->(dtstart, dtend, dtstart_field = dtstart_query_field, dtend_field = dtend_query_field) { MongoidOccurrenceViews::Queries::OccursBetween.criteria(self, dtstart, dtend, dtstart_field: dtstart_field, dtend_field: dtend_field) }
        scope :occurs_from, ->(date_time, dtstart_field = dtstart_query_field) { MongoidOccurrenceViews::Queries::OccursFrom.criteria(self, date_time, dtstart_field: dtstart_field) }
        scope :occurs_on, -> (date_time, dtstart_field = dtstart_query_field, dtend_field = dtend_query_field) { MongoidOccurrenceViews::Queries::OccursOn.criteria(criteria, date_time, dtstart_field: dtstart_field, dtend_field: dtend_field) }
        scope :occurs_until, ->(date_time, dtend_field = dtend_query_field) { MongoidOccurrenceViews::Queries::OccursUntil.criteria(self, date_time, dtend_field: dtend_field) }

        scope :order_by_start, ->(order = :asc, dtstart_field = dtstart_query_field) { MongoidOccurrenceViews::Queries::OrderByStart.criteria(self, order, dtstart_field: dtstart_field) }
        scope :order_by_end, ->(order = :asc, dtend_field = dtend_query_field) { MongoidOccurrenceViews::Queries::OrderByEnd.criteria(self, order, dtend_field: dtend_field) }

        CreateOccurrencesOrderingView.call(self)
        CreateExpandedOccurrencesView.call(self)
      end

      def dtstart_query_field
        within_view? ? :_dtstart : :"#{chained_relations.last}.ds"
      end

      def dtend_query_field
        within_view? ? :_dtend : :"#{chained_relations.last}.de"
      end

      def within_view?
        collection.name.include? MongoidOccurrenceViews::Event::HasViewsOnOccurrences::EXPANDED_VIEW_NAME_SUFFIX
      end

      # def within_expanded_view?
      #   collection.name.include? MongoidOccurrenceViews::Event::HasViewsOnOccurrences::EXPANDED_VIEW_NAME_SUFFIX
      # end

      # def within_ordering_view?
      #   collection.name.include? MongoidOccurrenceViews::Event::HasViewsOnOccurrences::ORDERING_VIEW_NAME_SUFFIX
      # end
    end
  end
end
