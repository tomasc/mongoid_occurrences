require 'mongoid_occurrence_views/queries/query'

module MongoidOccurrenceViews
  module Queries
    class OccursBetween < Query
      def initialize(base_criteria, dtstart, dtend, options = {})
        @base_criteria = base_criteria

        @dtstart = dtstart
        @dtend = dtend

        @dtstart_field = options.fetch(:dtstart_field, :dtstart)
        @dtend_field = options.fetch(:dtend_field, :dtend)
      end

      def criteria
        base_criteria.lte(dtstart_field => adjusted_dtend)
                     .gte(dtend_field => adjusted_dtstart)
      end

      private

      def adjusted_dtstart
        return dtstart.beginning_of_day if dtstart.instance_of?(Date)

        dtstart
      end

      def adjusted_dtend
        return dtend.end_of_day if dtend.instance_of?(Date)

        dtend
      end

      attr_reader :dtstart, :dtend, :dtstart_field, :dtend_field
    end
  end
end
