FactoryBot.define do
  factory :embedded_event do

    trait :today do
      occurrences { [ build(:occurrence, :today) ] }
    end

    trait :yesterday do
      occurrences { [ build(:occurrence, :yesterday) ] }
    end

    trait :tomorrow do
      occurrences { [ build(:occurrence, :tomorrow) ] }
    end

    trait :last_week do
      occurrences { [ build(:occurrence, :last_week) ] }
    end

    trait :next_week do
      occurrences { [ build(:occurrence, :next_week) ] }
    end

    trait :today_until_tomorrow do
      occurrences { [ build(:occurrence, :today_until_tomorrow) ] }
    end

    trait :recurring_daily_this_week do
      occurrences { [ build(:occurrence, :recurring_daily_this_week) ] }
    end
  end
end
