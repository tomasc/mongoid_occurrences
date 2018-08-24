module MongoidOccurrenceViews
  module Queries
    class DateTimeRange < Query
      def initialize(klass, dtstart, dtend)
        @klass = klass
        @dtstart = dtstart
        @dtend = dtend
      end

      def criteria
        _dtstart = dtstart.beginning_of_day if dtstart.instance_of?(Date)
        _dtstart = dtstart.utc

        _dtend = dtend.end_of_day if dtend.instance_of?(Date)
        _dtend = dtend.utc

        base_class_criteria.lte(dtstart_field => dtend.to_datetime)
                           .gte(dtend_field => dtstart.to_datetime)
      end

      private

      attr_reader :dtstart, :dtend
    end
  end
end
