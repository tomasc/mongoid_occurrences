require 'mongoid_occurrence_views/aggregations/aggregation'

module MongoidOccurrenceViews
  module Aggregations
    class OccursOn < Aggregation
      option :allow_disk_use, true
      option :sort_key, :_dtstart
      option :sort_order, :asc

      def initialize(base_criteria, date_time, options = {})
        @base_criteria = base_criteria
        @date_time = date_time
        @options = options

        @aggregation = base_criteria.klass
                                    .collection
                                    .aggregate(
                                      (selectors + pipeline),
                                      allow_disk_use: allow_disk_use
                                    )
      end

      def instantiate
        aggregation.map do |doc|
          base_criteria.klass.instantiate(doc)
        end
      end

      private

      def criteria
        base_criteria.occurs_on(date_time)
      end

      def pipeline
        [
          { '$addFields' => { '_daily_occurrences' => '$daily_occurrences' } },
          { '$unwind' => { 'path' => '$_daily_occurrences' } },
          { '$addFields' => { '_dtstart' => '$_daily_occurrences.ds', '_dtend' => '$_daily_occurrences.de' } },
          { '$match' => Queries::OccursOn.criteria(base_criteria, date_time, dtstart_field: '_dtstart', dtend_field: '_dtend').selector },
          { '$sort' => { sort_key => { asc: 1, desc: -1 }[sort_order] } }
        ]
      end

      attr_reader :aggregation, :date_time, :options
    end
  end
end
