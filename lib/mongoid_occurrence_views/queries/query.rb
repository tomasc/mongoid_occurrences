module MongoidOccurrenceViews
  module Queries
    class Query
      def initialize(klass)
        @klass = klass
      end

      def self.criteria(*args)
        new(*args).criteria
      end

      def criteria
        raise NotImplementedError
      end

      private

      attr_reader :klass

      def dtstart_field
        within_view? ? '_dtstart' : 'occurrences.daily_occurrences.ds'
      end

      def dtend_field
        within_view? ? '_dtend' : 'occurrences.daily_occurrences.de'
      end

      def base_class_criteria
        klass.criteria
      end

      def within_view?
        klass.collection.name =~ /occurrences_view/i
      end

      def within_expanded_view?
        klass.collection.name.include? MongoidOccurrenceViews::Event::HasViewsOnOccurrences::EXPANDED_VIEW_NAME_SUFFIX
      end

      def within_ordering_view?
        klass.collection.name.include? MongoidOccurrenceViews::Event::HasViewsOnOccurrences::ORDERING_VIEW_NAME_SUFFIX
      end
    end
  end
end
