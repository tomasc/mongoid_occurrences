module MongoidOccurrenceViews
  module Queries
    class Query
      def initialize(base_criteria)
        @base_criteria = base_criteria
      end

      def self.criteria(*args)
        new(*args).criteria
      end

      def criteria
        raise NotImplementedError
      end

      private

      attr_reader :base_criteria
    end
  end
end
