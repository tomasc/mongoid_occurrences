module MongoidOccurrenceViews
  module Event
    class CreateOccurrencesOrderingView < CreateView
      def view_name
        klass.occurrences_ordering_view_name
      end

      def pipeline
        [add_fields].flatten
      end

      private

      def add_fields
        { '$addFields': { '_dtstart': order_dtstart_field, '_dtend': order_dtend_field } }
      end

      def order_dtstart_field
        min = "$#{chained_relations.last}.ds"
        chained_relations.length.times { min = { '$min': min } }
        min
      end

      def order_dtend_field
        max = "$#{chained_relations.last}.de"
        chained_relations.length.times { max = { '$max': max } }
        max
      end
    end
  end
end
