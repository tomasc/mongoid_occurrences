module MongoidOccurrenceViews
  module Queries
    class OrderByStart < Query
      def initialize(klass, order)
        @klass = klass
        @order = order
      end

      def criteria
        with_ordering_view do
          base_class_criteria.order_by(_sort_dtstart: order)
        end
      end

      private

      attr_reader :order
    end
  end
end
