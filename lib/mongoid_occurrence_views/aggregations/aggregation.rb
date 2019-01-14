module MongoidOccurrenceViews
  module Aggregations
    class Aggregation
      def initialize(base_criteria)
        @base_criteria = base_criteria
      end

      def instantiate
        raise NotImplementedError
      end

      private

      def selectors
        [
          { '$match' => { '$and' => [criteria.selector] } },
          { '$sort' => criteria.options[:sort] },
          { '$limit' => criteria.options[:limit] }
        ].map { |i| i.delete_if { |_, v| v.blank? } }.reject(&:blank?)
      end

      attr_reader :base_criteria
    end
  end
end
