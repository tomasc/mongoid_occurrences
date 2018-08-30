module MongoidOccurrenceViews
  module Queries
    class OccursBetween < Query
      def initialize(base_criteria, dtstart, dtend, options = {})
        @base_criteria = base_criteria
        @dtstart = dtstart
        @dtend = dtend
        @dtstart_field = options.fetch(:dtstart_field)
        @dtend_field = options.fetch(:dtend_field)
      end

      def criteria
        _dtstart = dtstart.beginning_of_day if dtstart.instance_of?(Date)
        _dtstart = dtstart.utc

        _dtend = dtend.end_of_day if dtend.instance_of?(Date)
        _dtend = dtend.utc

        base_criteria.lte(dtstart_field => dtend.to_datetime)
                           .gte(dtend_field => dtstart.to_datetime)
      end

      private

      attr_reader :dtstart, :dtend, :dtstart_field, :dtend_field
    end
  end
end
