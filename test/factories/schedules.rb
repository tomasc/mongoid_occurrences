FactoryBot.define do
  factory :schedule, class: IceCube::Schedule do
    trait :daily_this_week do
      start_time { Time.now.beginning_of_day }
      after(:build) { |s| s.add_recurrence_rule(IceCube::Rule.daily(1).count(7)) }
    end
  end
end
