module MongoidOccurrenceViews
  module HasFieldsFromAggregation
    def dtstart
      @dtstart ||= DateTime.demongoize(
        self['_dtstart'] ||
          daily_occurrences.unscoped.order(dtstart: :asc).pluck(:dtstart).first
      )
    end

    def dtend
      @dtend ||= DateTime.demongoize(
        self['_dtend'] ||
          daily_occurrences.unscoped.order(dtend: :desc).pluck(:dtend).first
      )
    end

    def all_day
      return unless dtstart && dtend

      dtstart.to_i == dtstart.beginning_of_day.to_i &&
        dtend.to_i == dtend.end_of_day.to_i
    end
    alias all_day? all_day
  end
end
