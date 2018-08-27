module MongoidOccurrenceViews
  module Event
    module HasViewsOnOccurrences
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def occurrences_ordering_view_name
          [collection.name, 'occurrences_ordering_view'].join('__').freeze
        end

        def expanded_occurrences_view_name
          [collection.name, 'expanded_occurrences_view'].join('__').freeze
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
