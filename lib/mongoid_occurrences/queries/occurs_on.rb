require 'mongoid_occurrences/queries/query'

module MongoidOccurrences
  module Queries
    class OccursOn < Query
      def initialize(base_criteria, date_time, options = {})
        @base_criteria = base_criteria
        @date_time = date_time
        @options = options
      end

      def criteria
        OccursBetween.criteria(base_criteria, adjusted_dtstart.utc, adjusted_dtend.utc, options)
      end

      private

      def adjusted_dtstart
        date_time.instance_of?(Date) ? date_time.beginning_of_day : date_time
      end

      def adjusted_dtend
        date_time.instance_of?(Date) ? date_time.end_of_day : date_time
      end

      attr_reader :date_time, :options
    end
  end
end
