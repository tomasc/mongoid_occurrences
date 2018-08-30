module MongoidOccurrenceViews
  module Queries
    class OccursUntil < Query
      def initialize(base_criteria, date_time, options = {})
        @base_criteria = base_criteria
        @date_time = date_time
        @dtend_field = options.fetch(:dtend_field)
      end

      def criteria
        _date_time = date_time.beginning_of_day if date_time.instance_of?(Date)
        _date_time = date_time.utc

        base_criteria.lte(dtend_field => _date_time)
      end

      private

      attr_reader :date_time, :dtend_field
    end
  end
end
