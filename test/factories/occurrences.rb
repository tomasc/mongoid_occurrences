FactoryBot.define do
  factory :occurrence do
    all_day { false }

    trait :today do
      dtstart { DateTime.now.beginning_of_day + 4.hours }
      dtend { DateTime.now.beginning_of_day + 6.hours }
    end

    trait :today_until_tomorrow do
      dtstart { DateTime.now.beginning_of_day + 4.hours }
      dtend { DateTime.now.beginning_of_day + 2.days }
    end

    trait :recurring_daily_this_week do
      dtstart { DateTime.now.beginning_of_day + 4.hours }
      dtend { DateTime.now.beginning_of_day + 6.hours }
      schedule { build(:schedule, :daily_this_week) }
    end
  end
end
