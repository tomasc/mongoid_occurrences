module MongoidOccurrences
  module Occurrence
    module HasSchedule
      SCHEDULE_DURATION = 1.year

      module ClassMethods
        def embedded_in_event(name, options = {})
          super(name, options)

          field :schedule, type: MongoidIceCubeExtension::Schedule
          field :schedule_dtstart, type: Time
          field :schedule_dtend, type: Time

          before_validation :nil_schedule, unless: :recurring?
        end
      end

      def schedule_dtstart
        read_attribute(:schedule_dtstart) ||
          (dtstart.try(:to_time) || Time.zone.now)
      end

      def schedule_dtend
        read_attribute(:schedule_dtend) ||
          (schedule_dtstart + SCHEDULE_DURATION)
      end

      def recurrence_rule
        schedule&.recurrence_rules&.first
      end

      def recurrence_rule=(value)
        case value
        when NilClass, 'null'
          @recurrence_rule = nil
          self.schedule = nil
        else
          @recurrence_rule = IceCube::Rule.from_hash(JSON.parse(value))
          self.schedule = IceCube::Schedule.new(schedule_dtstart) { |s| s.add_recurrence_rule(@recurrence_rule) }
        end
      end

      def recurring?
        schedule.present?
      end

      private

      def nil_schedule
        self.schedule = nil
      end
    end
  end
end
