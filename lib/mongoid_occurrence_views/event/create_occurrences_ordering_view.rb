module MongoidOccurrenceViews
  module Event
    class CreateOccurrencesOrderingView < CreateView
      def view_name
        klass.occurrences_ordering_view_name
      end

      def pipeline
        [unwind_embedded_relations,
         add_order_fields].reject(&:nil?).flatten
      end

      private

      def unwind_embedded_relations
        return unless relations_to_unwind.length >= 1
        relations_to_unwind.map do |rel|
          { '$unwind': "$#{rel}" }
        end
      end

      def relations_to_unwind
        chained_relations[0...-2]
      end

      def add_order_fields
        { '$addFields': { '_order_dtstart': order_dtstart_field, '_order_dtend': order_dtend_field } }
      end

      def order_dtstart_field
        order_field(method: 'min', field_name: 'ds')
      end

      def order_dtend_field
        order_field(method: 'max', field_name: 'de')
      end

      def order_field(method:, field_name:)
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
