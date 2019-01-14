require 'mongoid_occurrence_views/queries/query'

module MongoidOccurrenceViews
  module Queries
    class OccursUntil < Query
      def initialize(base_criteria, date_time, options = {})
        @base_criteria = base_criteria
        @date_time = date_time
        @dtend_field = options.fetch(:dtend_field, :dtend)
      end

      def criteria
        base_criteria.lte(dtend_field => adjusted_date_time)
      end

      private

      def adjusted_date_time
        return date_time.end_of_day if date_time.instance_of?(Date)
        date_time
      end

      attr_reader :date_time, :dtend_field
    end
  end
end
