require 'mongoid_occurrences/queries/query'

module MongoidOccurrences
  module Queries
    class OccursBetween < Query
      option :dtstart_field, :dtstart
      option :dtend_field, :dtend

      def initialize(base_criteria, dtstart, dtend, options = {})
        @base_criteria = base_criteria
        @dtstart = dtstart
        @dtend = dtend
        @options = options
      end

      def criteria
        base_criteria.lte(dtstart_field => adjusted_dtend.utc)
                     .gte(dtend_field => adjusted_dtstart.utc)
      end

      private

      def adjusted_dtstart
        dtstart.instance_of?(Date) ? dtstart.beginning_of_day : dtstart
      end

      def adjusted_dtend
        dtend.instance_of?(Date) ? dtend.beginning_of_day : dtend
      end

      attr_reader :dtstart, :dtend, :options
    end
  end
end
