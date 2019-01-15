require 'mongoid_occurrences/daily_occurrence/has_scopes'

module MongoidOccurrences
  class DailyOccurrence
    include Mongoid::Document
    include HasScopes

    attr_accessor :operator

    field :ds, as: :dtstart, type: DateTime
    field :de, as: :dtend, type: DateTime

    validates :dtstart, presence: true
    validates :dtend, presence: true

    def operator
      @operator ||= :append
    end

    def all_day
      dtstart.to_i == dtstart.beginning_of_day.to_i &&
        dtend.to_i == dtend.end_of_day.to_i
    end
    alias all_day? all_day

    def <=>(other)
      sort_key <=> other.sort_key
    end

    def sort_key
      [dtstart, dtend]
    end

    def to_range
      (dtstart..dtend)
    end

    def overlaps?(occurrence)
      to_range.overlaps?(occurrence.to_range)
    end
  end
end
