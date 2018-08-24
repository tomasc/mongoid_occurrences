module MongoidOccurrenceViews
  module Event
    class CreateExpandedOccurrencesView
      def initialize(klass)
        @klass = klass
      end

      def self.call(*args)
        new(*args).call
      end

      def call
        CreateMongodbView.call(
          name: klass.expanded_occurrences_view_name,
          collection: klass.collection.name,
          pipeline: pipeline
        )
      end

      def pipeline
        [add_fields,
         unwind_associations_to_parent,
         add_datetime_fields].flatten
      end

      private

      attr_reader :klass

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

      def chained_relations
        relation_chain.each_with_index.map do |_, i|
          relation_chain[0..i].join('.')
        end
      end

      def relation_chain
        return base_relations unless event_relation.present?
        [event_relation.first.store_as, base_relations].flatten
      end

      # NOTE: event_relations?
      def event_relation
        klass.relations.values.select do |rel|
          event_class_names.include?(rel.options[:class_name])
        end
      end

      def event_class_names
        ObjectSpace.each_object(Class).select do |cls|
          cls.included_modules.include?(MongoidOccurrenceViews::Event)
        end.map(&:to_s)
      end

      # NOTE: base_relation_names?
      def base_relations
        %w[occurrences daily_occurrences]
      end
    end
  end
end
