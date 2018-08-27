module MongoidOccurrenceViews
  module Event
    class CreateExpandedOccurrencesView < CreateView
      def view_name
        klass.expanded_occurrences_view_name
      end

      def pipeline
        [add_fields,
         unwind_associations_to_parent,
         add_datetime_fields].flatten
      end

      private

      def add_fields
        { '$addFields': { "_#{relation_chain.first}": "$#{relation_chain.first}" } }
      end

      def unwind_associations_to_parent
        chained_relations.map do |chain|
          { '$unwind': "$_#{chain}" }
        end
      end

      def add_datetime_fields
        { '$addFields': {
          '_dtstart': "$_#{chained_relations.last}.ds",
          '_dtend': "$_#{chained_relations.last}.de",
          '_sort_key': "$_#{chained_relations.last}.ds"
        } }
      end
    end
  end
end
