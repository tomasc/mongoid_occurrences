module MongoidOccurrenceViews
  module Event
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def embeds_many_occurrences(options = {})
        embeds_many :occurrences, class_name: options.fetch(:class_name)
        accepts_nested_attributes_for :occurrences, allow_destroy: true

        scope :for_date_time, -> (date_time) {
          MongoidOccurrenceViews::Event::ForDateTime.call(self, date_time)
        }

        scope :for_date_time_range, ->(dtstart, dtend) {
          MongoidOccurrenceViews::Event::ForDateTimeRange.call(self, dtstart, dtend)
        }

        scope :from_date_time, ->(date_time) {
          MongoidOccurrenceViews::Event::FromDateTime.call(self, date_time)
        }

        scope :to_date_time, ->(date_time) {
          MongoidOccurrenceViews::Event::ToDateTime.call(self, date_time)
        }

        CreateOccurrencesView.call(self)
        CreateExpandedOccurrencesView.call(self)
      end

      def occurrences_view_name
        [collection.name, 'occurrences_view'].join('__').freeze
      end

      def expanded_occurrences_view_name
        [collection.name, 'expanded_occurrences_view'].join('__').freeze
      end

      def with_expanded_occurrences_view(&block)
        criteria.with collection: expanded_occurrences_view_name, &block
      end

      def with_occurrences_view(&block)
        criteria.with collection: occurrences_view_name, &block
      end
    end
  end
end
