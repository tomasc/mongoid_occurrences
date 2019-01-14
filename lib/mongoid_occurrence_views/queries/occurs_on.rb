require 'mongoid_occurrence_views/queries/query'

module MongoidOccurrenceViews
  module Queries
    class OccursOn < Query
      def initialize(base_criteria, date_time, options = {})
        @base_criteria = base_criteria
        @date_time = date_time
        @dtstart_field = options.fetch(:dtstart_field, :dtstart)
        @dtend_field = options.fetch(:dtend_field, :dtend)
      end

      def criteria
        OccursBetween.criteria(base_criteria, adjusted_dtstart, adjusted_dtend)
      end

      private

      def adjusted_dtstart
        return date_time.beginning_of_day if date_time.instance_of?(Date)

        date_time
      end

      def adjusted_dtend
        return date_time.end_of_day if date_time.instance_of?(Date)

        date_time
      end

      attr_reader :date_time, :dtstart_field, :dtend_field
    end
  end
end
