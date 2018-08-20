require "mongoid"
require "mongoid_ice_cube_extension"

module MongoidOccurrenceViews
  module Occurrence
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def embedded_in_event(options = {})
        field :dtstart, type: DateTime
        field :dtend, type: DateTime
        field :all_day, type: Boolean, default: false

        field :schedule, type: MongoidIceCubeExtension::Schedule
        field :occurrences, type: Array

        validates_presence_of :dtstart
        validates_presence_of :dtend

        before_validation :set_occurrences
      end
    end

    private

    def set_occurrences
      self.occurrences = schedule.present? ? occurrences_from_schedule : occurrences_from_model
    end

    def occurrences_from_schedule
      schedule.occurrences(dtstart + 1.year).collect do |occurrence|
        occurrence_dtstart = occurrence.start_time
        occurrence_dtend = occurrence.end_time
        occurrence_dtend = occurrence.end_time.change(hour: self.dtend.hour, min: self.dtend.minute)
        { dtstart: occurrence_dtstart, dtend: occurrence_dtend, all_day: all_day }
      end
    end

    def occurrences_from_model
      [{ dtstart: dtstart, dtend: dtend, all_day: all_day }]
    end
  end
end
