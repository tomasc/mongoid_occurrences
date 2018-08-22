require 'mongoid_occurrence_views/event/create_occurrence_view'
require 'mongoid_occurrence_views/event/create_expanded_occurrence_view'

module MongoidOccurrenceViews
  module Event
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def embeds_many_occurrences(options = {})
        embeds_many :occurrences, class_name: options.fetch(:class_name)
        accepts_nested_attributes_for :occurrences, allow_destroy: true

        create_occurrences_view
        create_expanded_occurrences_view
      end

      def occurrences_view_name
        [collection.name, 'occurrences_view'].join('__').freeze
      end

      def expanded_occurrences_view_name
        [collection.name, 'expanded_occurrences_view'].join('__').freeze
      end

      def with_expanded_occurrences_view(&block)
        criteria.with(collection: expanded_occurrences_view_name) { block }
      end

      def with_occurrences_view(&block)
        criteria.with(collection: occurrences_view_name) { block }
      end

      private

      def create_occurrences_view
        MongoidOccurrenceViews::Event::CreateOccurrencesView.call(self)
      end

      def create_expanded_occurrences_view
        MongoidOccurrenceViews::Event::CreateExpandedOccurrencesView.call(self)
      end
    end
  end
end
