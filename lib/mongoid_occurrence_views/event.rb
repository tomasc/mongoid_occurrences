module MongoidOccurrenceViews
  module Event
    def self.included(base)
      base.class_eval do
        include HasViewsOnOccurrences
        include HasOccurrenceScopes
      end
      base.extend ClassMethods
    end

    module ClassMethods
      def embeds_many_occurrences(options = {})
        embeds_many :occurrences, class_name: options.fetch(:class_name)
        accepts_nested_attributes_for :occurrences, allow_destroy: true, reject_if: :all_blank

        CreateExpandedOccurrencesView.call(self) unless embedded?
        # CreateOccurrencesOrderingView.call(self) unless embedded?
      end
    end
  end
end
