module MongoidOccurrenceViews
  class CreateExpandedOccurrencesView
    DTSTART_FIELD = 'ds'.freeze
    DTEND_FIELD = 'de'.freeze

    def initialize(klass)
      @klass = klass
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      CreateView.call(
        name: klass.expanded_occurrences_view_name,
        collection: klass.collection.name,
        pipeline: pipeline
      )
    end

    def pipeline
      [
        add_base_relation_fields,
        unwind_relations,
        add_date_and_sort_key_fields
      ].flatten
    end

    private

    attr_reader :klass

    def add_base_relation_fields
      { '$addFields': { "_#{relation_chain.first}": "$#{relation_chain.first}" } }
    end

    def add_date_and_sort_key_fields
      { '$addFields': {
        '_dtstart': "$_#{chained_relations.last}.#{DTSTART_FIELD}",
        '_dtend': "$_#{chained_relations.last}.#{DTEND_FIELD}",
        '_sort_key': "$_#{chained_relations.last}.#{DTSTART_FIELD}"
        }
      }
    end

    def unwind_relations
      chained_relations.map { |chain| { '$unwind': "$_#{chain}" } }
    end

    def chained_relations
      relation_chain.each_with_index.map do |_, i|
        relation_chain[0..i].join('.')
      end
    end

    def relation_chain
      return base_relations unless event_relation.present?
      [event_relation.first.store_as, base_relations].flatten
    end

    def event_relation
      klass.relations.values.select do |rel|
        event_class_names.include?(rel.options[:class_name])
      end
    end

    def event_class_names
      MongoidOccurrenceViews.event_classes.map(&:to_s)
    end

    def base_relations
      %w[occurrences daily_occurrences]
    end
  end
end
