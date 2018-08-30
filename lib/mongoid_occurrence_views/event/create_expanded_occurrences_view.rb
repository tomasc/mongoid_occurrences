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
        { '$addFields': { "_#{occurrence_relation_chain.first}": "$#{occurrence_relation_chain.first}" } }
      end

      def unwind_associations_to_parent
        occurrence_relations_chained.map do |chain|
          { '$unwind': "$_#{chain}" }
        end
      end

      def add_datetime_fields
        { '$addFields': {
          '_dtstart': "$_#{occurrence_relations_chained.last}.ds",
          '_dtend': "$_#{occurrence_relations_chained.last}.de",
        } }
      end
    end
  end
end
