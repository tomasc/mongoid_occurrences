module MongoidOccurrenceViews
  module Event
    def self.included(base)
      base.include HasViewsOnOccurrences
      base.include HasOccurrenceScopes
      base.extend ClassMethods
    end

    module ClassMethods
      def embeds_many_occurrences(options = {})
        embeds_many :occurrences, class_name: options.fetch(:class_name)
        accepts_nested_attributes_for :occurrences, allow_destroy: true

        CreateExpandedOccurrencesView.call(self) unless embedded?
        # CreateOccurrencesOrderingView.call(self) unless embedded?
      end
    end
  end
end
