module MongoidOccurrenceViews
  module Queries
    class DateTime < Query
      def initialize(base_class_criteria, date_time, options = {})
        @base_class_criteria = base_class_criteria
        @date_time = date_time
        @dtstart_field = options.fetch(:dtstart_field)
        @dtend_field = options.fetch(:dtend_field)
      end

      def criteria
        _date_time = date_time.beginning_of_day if date_time.instance_of?(Date)
        _date_time = date_time.utc

        base_class_criteria.lte(dtstart_field => _date_time)
                           .gte(dtend_field => _date_time)
      end

      private

      attr_reader :base_class_criteria, :date_time, :dtstart_field, :dtend_field
    end
  end
end
