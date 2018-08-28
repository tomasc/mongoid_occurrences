module MongoidOccurrenceViews
  module Queries
    class OrderByEnd < Query
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
        when within_ordering_view? then :_order_dtend
        when within_expanded_view? then :_dtend
        else :'occurrences.daily_occurrences.de'
        end
      end
    end
  end
end
