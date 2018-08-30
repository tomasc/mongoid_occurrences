module MongoidOccurrenceViews
  module Event
    class CreateView
      delegate(
        :occurrence_relations_chained,
        :occurrence_relation_chain,

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
    end
  end
end
