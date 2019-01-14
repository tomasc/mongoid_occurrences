require 'mongoid/enum_attribute'

module MongoidOccurrenceViews
  module Occurrence
    module HasOperators
      def self.prepended(base)
        base.scope :with_operators, ->(operators) { criteria.in(operator: Array(operators)) }
      end

      module ClassMethods
        def embedded_in_event(options = {})
          super(options)

          include Mongoid::EnumAttribute

          enum :operator, %i[append replace remove], default: :append
        end
      end
    end
  end
end
