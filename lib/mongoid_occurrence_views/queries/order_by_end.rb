module MongoidOccurrenceViews
  module Queries
    class OrderByEnd < Query
      def initialize(base_criteria, order, options = {})
        @base_criteria = base_criteria
        @order = order
        @dtend_field = options.fetch(:dtend_field)
      end

      def criteria
        base_criteria.order_by(dtend_field => order)
      end

      private

      attr_reader :order, :dtend_field
    end
  end
end
