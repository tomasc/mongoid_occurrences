module MongoidOccurrenceViews
  module Queries
    class Query
      def initialize(base_class_criteria)
        @base_class_criteria = base_class_criteria
      end

      def self.criteria(*args)
        new(*args).criteria
      end

      def criteria
        raise NotImplementedError
      end

      private

      attr_reader :base_class_criteria

      # def dtstart_field
      #   within_view? ? :_dtstart : :"#{klass.chained_relations.last}.ds"
      # end
      #
      # def dtend_field
      #   within_view? ? :_dtend : :"#{klass.chained_relations.last}.de"
      # end

      # def base_class_criteria
      #   klass.criteria
      # end

      # def within_view?
      #   within_expanded_view? || within_ordering_view?
      # end
      #
      # def within_expanded_view?
      #   klass.collection.name.include? MongoidOccurrenceViews::Event::HasViewsOnOccurrences::EXPANDED_VIEW_NAME_SUFFIX
      # end
      #
      # def within_ordering_view?
      #   klass.collection.name.include? MongoidOccurrenceViews::Event::HasViewsOnOccurrences::ORDERING_VIEW_NAME_SUFFIX
      # end
    end
  end
end
