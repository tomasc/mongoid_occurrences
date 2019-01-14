module MongoidOccurrenceViews
  module Aggregations
    class Aggregation
      def self.option(name, default_value=nil)
        define_method(name) do
          HashWithIndifferentAccess[options].fetch(name, default_value)
        end
      end

      option :allow_disk_use, true
      option :sort_key, :_dtstart
      option :sort_order, :asc

      def initialize(base_criteria, options = {})
        @base_criteria = base_criteria
        @options = options
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
