FactoryBot.define do
  factory :occurrence do
    trait :all_day do
      all_day { true }
    end

    trait :today do
      dtstart { DateTime.now.beginning_of_day + 4.hours }
      dtend { DateTime.now.beginning_of_day + 6.hours }
    end

    trait :today_until_tomorrow do
      dtstart { DateTime.now.beginning_of_day + 4.hours }
      dtend { DateTime.now.beginning_of_day + 1.day }
    end

    trait :recurring_daily_this_week do
      dtstart { DateTime.now.beginning_of_day }
      dtend { DateTime.now.beginning_of_day + 4.hours }
      schedule { build(:schedule, :daily_this_week) }
    end
  end
end
