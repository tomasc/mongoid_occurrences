module MongoidOccurrenceViews
  module Event
    class CreateOccurrencesOrderingView < CreateView
      def view_name
        klass.occurrences_ordering_view_name
      end

      def pipeline
        [add_sort_fields]
      end

      private

      def add_sort_fields
        { '$addFields': { '_sort_dtstart': sort_dtstart_field, '_sort_dtend': sort_dtend_field } }
      end

      def sort_dtstart_field
        sort_field(method: 'min', field_name: 'ds')
      end

      def sort_dtend_field
        sort_field(method: 'max', field_name: 'de')
      end

      def sort_field(method:, field_name:)
        {
          "$#{method}": {
            '$map': {
              'input': "$#{chained_relations.last}.#{field_name}",
              'as': 'el',
              'in': { '$arrayElemAt': ['$$el', 0] }
            }
          }
        }
      end
    end
  end
end
