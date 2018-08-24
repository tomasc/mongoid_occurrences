module MongoidOccurrenceViews
  module Queries
    class ToDateTime < Query
      def initialize(klass, date_time)
        @klass = klass
        @date_time = date_time
      end

      def criteria
        _date_time = date_time.beginning_of_day if date_time.instance_of?(Date)
        _date_time = date_time.utc

        base_class_criteria.lte(dtend_field => _date_time)
      end

      private

      attr_reader :date_time
    end
  end
end
