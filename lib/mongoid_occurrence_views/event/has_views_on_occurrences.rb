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

        def chained_relations
          relation_chain.each_with_index.map do |_, i|
            relation_chain[0..i].join('.')
          end
        end

        def relation_chain
          return occurrence_relation_names unless event_relation.present?
          [event_relation.first.store_as, occurrence_relation_names].flatten
        end

        # NOTE: event_relations?
        def event_relation
          self.relations.values.select do |rel|
            event_class_names.include?(rel.options[:class_name])
          end
        end

        def event_class_names
          ObjectSpace.each_object(Class).select do |cls|
            cls.included_modules.include?(MongoidOccurrenceViews::Event)
          end.map(&:to_s)
        end

        def occurrence_relation_names
          %w[occurrences daily_occurrences]
        end
      end
    end
  end
end
