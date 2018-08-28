module MongoidOccurrenceViews
  module Queries
    class OrderByEnd < Query
      def initialize(klass, order)
        @klass = klass
        @order = order
      end

      def criteria
        klass.order_by(dtend_field => order)
      end

      private

      attr_reader :order
    end
  end
end
