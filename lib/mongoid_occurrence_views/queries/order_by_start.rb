module MongoidOccurrenceViews
  module Queries
    class OrderByStart < Query
      def initialize(base_criteria, order, options = {})
        @base_criteria = base_criteria
        @order = order
        @dtstart_field = options.fetch(:dtstart_field)
      end

      def criteria
        base_criteria.order_by(dtstart_field => order)
      end

      private

      attr_reader :order, :dtstart_field
    end
  end
end
