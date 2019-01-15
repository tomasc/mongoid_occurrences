FactoryBot.define do
  factory :daily_occurrence, class: MongoidOccurrences::DailyOccurrence do
    trait :all_day do
      after(:build) do |occ|
        occ.dtstart = occ.dtstart.beginning_of_day
        occ.dtend = occ.dtend.end_of_day
      end
    end
  end
end
