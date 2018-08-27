module MongoidOccurrenceViews
  module Event
    class CreateView
      def initialize(klass)
        @klass = klass
      end

      def self.call(*args)
        new(*args).call
      end

      def call
        CreateMongodbView.call(
          name: view_name,
          collection: klass.collection.name,
          pipeline: pipeline
        )
      end

      def pipeline
        raise NotImplementedError
      end

      def view_name
        raise NotImplementedError
      end

      private

      attr_reader :klass

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
