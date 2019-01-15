require 'mongoid_occurrences/queries/query'

module MongoidOccurrences
  module Queries
    class OccursFrom < Query
      option :dtstart_field, :dtstart

      def initialize(base_criteria, date_time, options = {})
        @base_criteria = base_criteria
        @date_time = date_time
        @options = options
      end

      def criteria
        base_criteria.gte(dtstart_field => adjusted_date_time)
      end

      private

      def adjusted_date_time
        date_time.instance_of?(Date) ? date_time.beginning_of_day : date_time
      end

      attr_reader :date_time, :options
    end
  end
end
