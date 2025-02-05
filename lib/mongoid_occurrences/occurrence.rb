require 'mongoid_occurrences/occurrence/has_daily_occurrences'
require 'mongoid_occurrences/occurrence/has_operators'
require 'mongoid_occurrences/occurrence/has_schedule'

module MongoidOccurrences
  module Occurrence
    def self.included(base)
      base.extend ClassMethods

      base.include Mongoid::Timestamps::Updated

      base.include HasDailyOccurrences

      base.prepend HasOperators
      base.singleton_class.prepend HasOperators::ClassMethods

      base.prepend HasSchedule
      base.singleton_class.prepend HasSchedule::ClassMethods
    end

    module ClassMethods
      def embedded_in_event(name, options = {})
        field :dtstart, type: DateTime
        field :dtend, type: DateTime
        field :all_day, type: Mongoid::Boolean

        embedded_in name, class_name: options.fetch(:class_name, nil), inverse_of: :occurrences

        after_validation :adjust_dates_for_all_day!, if: :changed?

        validates :dtstart, presence: true
        validates :dtend, presence: true

        validate :dtend_must_be_after_dtstart
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
      return unless dtstart? && dtend?

      self.dtstart = dtstart.beginning_of_day
      self.dtend = dtend.end_of_day
    end

    private

    def dtend_must_be_after_dtstart
      return unless dtstart.present? && dtend.present?

      if dtend < dtstart
        errors.add(:dtend, :must_be_after_dtstart)
      end
    end
  end
end
