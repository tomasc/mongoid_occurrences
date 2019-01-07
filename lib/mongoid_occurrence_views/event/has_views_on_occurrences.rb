module MongoidOccurrenceViews
  module Event
    module HasViewsOnOccurrences
      ORDERING_VIEW_NAME_SUFFIX = 'occurrences_ordering_view'.freeze
      EXPANDED_VIEW_NAME_SUFFIX = 'expanded_occurrences_view'.freeze

      def self.included(base)
        base.extend ClassMethods
      end

      def dtstart
        return unless self.class.within_view?
        DateTime.demongoize(self[:_dtstart])
      end

      def dtend
        return unless self.class.within_view?
        DateTime.demongoize(self[:_dtend])
      end

      def all_day
        return unless dtstart.present? && dtend.present?
        dtstart.to_i == dtstart.beginning_of_day.to_i &&
          dtend.to_i == dtend.end_of_day.to_i
      end
      alias all_day? all_day

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

        def occurrence_relations_chained
          occurrence_relation_chain.each_with_index.map do |_, i|
            occurrence_relation_chain[0..i].join('.')
          end
        end

        def occurrence_relation_chain
          return occurrence_relation_names unless event_relations.present?
          [event_relations.first.store_as, occurrence_relation_names].flatten
        end

        def event_relations
          return unless self.relations.present?
          self.relations.values.select { |rel| is_event_relation?(rel) }
        end

        def is_event_relation?(rel)
          relation_class_name = rel.options[:class_name]
          return false unless relation_class_name.present?
          return true if event_class_names.include?(relation_class_name)
          return unless relation_class = relation_class_name.safe_constantize
          event_superclasses = event_class_names.map { |cn| cn.safe_constantize.ancestors }.flatten
          event_superclasses.include? relation_class
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
