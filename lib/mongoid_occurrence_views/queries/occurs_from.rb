module MongoidOccurrenceViews
  module Queries
    class OccursFrom < Query
      def initialize(base_criteria, date_time, options = {})
        @base_criteria = base_criteria
        @date_time = date_time
        @dtstart_field = options.fetch(:dtstart_field)
      end

      def criteria
        _date_time = date_time.end_of_day if date_time.instance_of?(Date)
        _date_time = date_time.utc

        base_criteria.gte(dtstart_field => _date_time)
      end

      private

      attr_reader :date_time, :dtstart_field
    end
  end
end
