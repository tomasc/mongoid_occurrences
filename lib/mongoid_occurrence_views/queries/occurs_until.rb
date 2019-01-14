require 'mongoid_occurrence_views/queries/query'

module MongoidOccurrenceViews
  module Queries
    class OccursUntil < Query
      option :dtend_field, :dtend

      def initialize(base_criteria, date_time, options = {})
        @base_criteria = base_criteria
        @date_time = date_time
        @options = options
      end

      def criteria
        base_criteria.lte(dtend_field => adjusted_date_time)
      end

      private

      def adjusted_date_time
        date_time.instance_of?(Date) ? date_time.end_of_day : date_time
      end

      attr_reader :date_time, :options
    end
  end
end
