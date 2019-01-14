require 'mongoid_occurrence_views/queries/query'

module MongoidOccurrenceViews
  module Queries
    class OccursFrom < Query
      def initialize(base_criteria, date_time, options = {})
        @base_criteria = base_criteria
        @date_time = date_time
        @dtstart_field = options.fetch(:dtstart_field, :dtstart)
      end

      def criteria
        base_criteria.gte(dtstart_field => adjusted_date_time)
      end

      private

      def adjusted_date_time
        return date_time.beginning_of_day if date_time.instance_of?(Date)

        date_time
      end

      attr_reader :date_time, :dtstart_field
    end
  end
end
