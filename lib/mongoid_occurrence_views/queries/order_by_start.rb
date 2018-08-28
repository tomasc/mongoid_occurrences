module MongoidOccurrenceViews
  module Queries
    class OrderByStart < Query
      def initialize(klass, order)
        @klass = klass
        @order = order
      end

      def criteria
        klass.order_by(order_field => order)
      end

      private

      attr_reader :order

      def order_field
        case
        when within_ordering_view? then :_order_dtstart
        when within_expanded_view? then :_dtstart
        else :'occurrences.daily_occurrences.ds'
        end
      end
    end
  end
end
