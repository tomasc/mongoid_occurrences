module MongoidOccurrenceViews
  module Event
    class CreateView
      delegate(
        :chained_relations,
        :relation_chain,

        to: :klass
      )

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
      
      # def chained_relations
      #   klass.chained_relations
      # end
      #
      # def relation_chain
      #   klass.relation_chain
      # end
      #
      # # NOTE: event_relations?
      # def event_relation
      #   klass.relations.values.select do |rel|
      #     event_class_names.include?(rel.options[:class_name])
      #   end
      # end
      #
      # def event_class_names
      #   ObjectSpace.each_object(Class).select do |cls|
      #     cls.included_modules.include?(MongoidOccurrenceViews::Event)
      #   end.map(&:to_s)
      # end
      #
      # def occurrence_relation_names
      #   %w[occurrences daily_occurrences]
      # end
    end
  end
end
