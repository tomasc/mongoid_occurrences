FactoryBot.define do
  factory :event do

    trait :today do
      occurrences { [ build(:occurrence, :today) ] }
    end

    trait :today_until_tomorrow do
      occurrences { [ build(:occurrence, :today_until_tomorrow) ] }
    end

    trait :recurring_daily_this_week do
      occurrences { [ build(:occurrence, :recurring_daily_this_week) ] }
    end
  end
end
