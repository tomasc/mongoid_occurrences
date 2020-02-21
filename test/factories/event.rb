FactoryBot.define do
  factory :event, class: ::Event do
    trait :occurring_today_and_tomorrow do
      occurrences { [build(:occurrence, :today), build(:occurrence, :tomorrow)] }
    end
  end
end
