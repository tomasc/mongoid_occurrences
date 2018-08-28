module MongoidOccurrenceViews
  module Event
    module HasViewsOnOccurrences
      ORDERING_VIEW_NAME_SUFFIX = 'occurrences_ordering_view'.freeze
      EXPANDED_VIEW_NAME_SUFFIX = 'expanded_occurrences_view'.freeze

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def occurrences_ordering_view_name
          [collection.name, ORDERING_VIEW_NAME_SUFFIX].join('__').freeze
        end

        def expanded_occurrences_view_name
          [collection.name, EXPANDED_VIEW_NAME_SUFFIX].join('__').freeze
        end

        def with_expanded_occurrences_view(&block)
          with_occurrences_view(expanded: true, &block)
        end

        def with_occurrences_ordering_view(&block)
          with_occurrences_view(expanded: false, &block)
        end

        def with_occurrences_view(options = {}, &block)
          expanded = options.delete(:expanded) { |_| true }
          options[:collection] ||= expanded ? expanded_occurrences_view_name : occurrences_ordering_view_name
          criteria.with(options, &block)
        end
      end
    end
  end
end
