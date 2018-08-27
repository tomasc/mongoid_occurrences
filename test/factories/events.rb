FactoryBot.define do
  factory :event do

    trait :today do
      occurrences { [ build(:occurrence, :today) ] }
    end

    trait :tomorrow do
      occurrences { [ build(:occurrence, :tomorrow) ] }
    end

    trait :yesterday do
      occurrences { [ build(:occurrence, :yesterday) ] }
    end

    trait :tomorrow_and_yesterday do
      occurrences { [ build(:occurrence, :tomorrow), build(:occurrence, :yesterday) ] }
    end

    trait :next_week_and_last_week do
      occurrences { [ build(:occurrence, :next_week), build(:occurrence, :last_week) ] }
    end

    trait :next_week do
      occurrences { [ build(:occurrence, :next_week) ] }
    end

    trait :last_week do
      occurrences { [ build(:occurrence, :last_week) ] }
    end

    trait :today_until_tomorrow do
      occurrences { [ build(:occurrence, :today_until_tomorrow) ] }
    end

    trait :recurring_daily_this_week do
      occurrences { [ build(:occurrence, :recurring_daily_this_week) ] }
    end
  end
end
