FactoryBot.define do
  factory :event_parent do

    trait :today do
      embedded_events { [ build(:embedded_event, :today) ] }
    end

    trait :today_until_tomorrow do
      embedded_events { [ build(:embedded_event, :today_until_tomorrow) ] }
    end

    trait :recurring_daily_this_week do
      embedded_events { [ build(:embedded_event, :recurring_daily_this_week) ] }
    end
  end
end
