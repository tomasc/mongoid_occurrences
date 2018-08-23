module MongoidOccurrenceViews
  module Event
    def self.included(base)
      base.class_eval do
        include MongoidOccurrenceViews::HasOccurrenceViews
      end
      base.extend ClassMethods
    end

    module ClassMethods
      def embeds_many_occurrences(options = {})
        embeds_many :occurrences, class_name: options.fetch(:class_name)
        accepts_nested_attributes_for :occurrences, allow_destroy: true

        scope :for_date_time, -> (date_time) {
          ForDateTime.call(self, date_time)
        }

        scope :for_date_time_range, ->(dtstart, dtend) {
          ForDateTimeRange.call(self, dtstart, dtend)
        }

        scope :from_date_time, ->(date_time) {
          FromDateTime.call(self, date_time)
        }

        scope :to_date_time, ->(date_time) {
          ToDateTime.call(self, date_time)
        }

        CreateOccurrencesView.call(self)
        CreateExpandedOccurrencesView.call(self)
      end
    end
  end
end
