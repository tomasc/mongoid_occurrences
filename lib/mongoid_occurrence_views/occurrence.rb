require 'mongoid_occurrence_views/occurrence/has_daily_occurrences'
require 'mongoid_occurrence_views/occurrence/has_operators'
require 'mongoid_occurrence_views/occurrence/has_schedule'
require 'mongoid_occurrence_views/occurrence/has_scopes'

module MongoidOccurrenceViews
  module Occurrence
    def self.included(base)
      base.extend ClassMethods

      base.include HasDailyOccurrences

      base.prepend HasOperators
      base.singleton_class.prepend HasOperators::ClassMethods

      base.prepend HasSchedule
      base.singleton_class.prepend HasSchedule::ClassMethods

      base.include HasScopes
    end

    module ClassMethods
      def embedded_in_event(options = {})
        field :dtstart, type: DateTime
        field :dtend, type: DateTime
        field :all_day, type: Boolean

        embedded_in :event, class_name: options.fetch(:class_name, nil)

        after_validation :adjust_dates_for_all_day!, if: :changed?

        validates :dtstart, presence: true
        validates :dtend, presence: true
      end
    end

    def all_day
      return super unless dtstart.present? && dtend.present?
      return super unless super.nil?

      dtstart.to_i == dtstart.beginning_of_day.to_i &&
        dtend.to_i == dtend.end_of_day.to_i
    end
    alias all_day? all_day

    def adjust_dates_for_all_day!
      return unless all_day?
      return unless dtstart.present? && dtend.present?

      write_attribute :dtstart, dtstart.try(:beginning_of_day)
      write_attribute :dtend, dtend.try(:end_of_day)
    end
  end
end
