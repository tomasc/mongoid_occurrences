require 'mongoid/enum_attribute'

module MongoidOccurrences
  module Occurrence
    module HasOperators
      def self.prepended(base)
        base.scope :with_operators, ->(operators) { criteria.in(_operator: Array(operators)) }

        %i[append replace remove].each do |o|
          define_method(o) { operator == o }
        end
      end

      module ClassMethods
        def embedded_in_event(name, options = {})
          super(name, options)

          include Mongoid::EnumAttribute
          enum :operator, %i[append replace remove], default: :append
        end
      end
    end
  end
end
