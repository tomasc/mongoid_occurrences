module MongoidOccurrenceViews
  module Event
    module HasOccurrenceScopes
      def self.include
        scope :occurs_between, ->(dtstart, dtend, dtstart_field = dtstart_query_field, dtend_field = dtend_query_field) { MongoidOccurrenceViews::Queries::OccursBetween.criteria(criteria, dtstart, dtend, dtstart_field: dtstart_field, dtend_field: dtend_field) }
        scope :occurs_from, ->(date_time, dtstart_field = dtstart_query_field) { MongoidOccurrenceViews::Queries::OccursFrom.criteria(criteria, date_time, dtstart_field: dtstart_field) }
        scope :occurs_on, -> (date_time, dtstart_field = dtstart_query_field, dtend_field = dtend_query_field) { MongoidOccurrenceViews::Queries::OccursOn.criteria(criteria, date_time, dtstart_field: dtstart_field, dtend_field: dtend_field) }
        scope :occurs_until, ->(date_time, dtend_field = dtend_query_field) { MongoidOccurrenceViews::Queries::OccursUntil.criteria(criteria, date_time, dtend_field: dtend_field) }

        scope :order_by_start, ->(order = :asc, dtstart_field = dtstart_query_field) { MongoidOccurrenceViews::Queries::OrderByStart.criteria(criteria, order, dtstart_field: dtstart_field) }
        scope :order_by_end, ->(order = :asc, dtend_field = dtend_query_field) { MongoidOccurrenceViews::Queries::OrderByEnd.criteria(criteria, order, dtend_field: dtend_field) }
      end

      def dtstart_query_field
        within_view? ? :_dtstart : :"#{occurrence_relations_chained.last}.ds"
      end

      def dtend_query_field
        within_view? ? :_dtend : :"#{occurrence_relations_chained.last}.de"
      end

      def within_view?
        collection.name.include? MongoidOccurrenceViews::Event::HasViewsOnOccurrences::EXPANDED_VIEW_NAME_SUFFIX
      end
    end
  end
end
