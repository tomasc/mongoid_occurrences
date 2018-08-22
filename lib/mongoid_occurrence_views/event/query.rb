module MongoidOccurrenceViews
  module Event
    class Query
      def initialize(klass)
        @klass = klass
      end

      def self.call(*args)
        new(*args).call
      end

      def call
        criteria
      end

      private

      attr_reader :klass

      def criteria
        raise NotImplementedError
      end

      def dtstart_field
        inside_view? ? :_dtstart : :'occurrences.daily_occurrences.ds'
      end

      def dtend_field
        inside_view? ? :_dtend : :'occurrences.daily_occurrences.de'
      end

      def base_class_criteria
        klass.criteria
      end

      def inside_view?
        klass.collection.name =~ /occurrences_view/i
      end
    end
  end
end
