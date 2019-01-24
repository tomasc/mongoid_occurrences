FactoryBot.define do
  factory :occurrence, class: ::Occurrence do
    trait :all_day do
      all_day { true }
    end

    trait :append do
      operator { :append }
    end

    trait :replace do
      operator { :replace }
    end

    trait :remove do
      operator { :remove }
    end

    trait :today do
      dtstart { Time.zone.now.beginning_of_day + 4.hours }
      dtend { Time.zone.now.beginning_of_day + 6.hours }
    end

    trait :tomorrow do
      dtstart { Time.zone.now.beginning_of_day + 1.day + 4.hours }
      dtend { Time.zone.now.beginning_of_day + 1.day + 6.hours }
    end

    trait :yesterday do
      dtstart { Time.zone.now.beginning_of_day - 1.day + 4.hours }
      dtend { Time.zone.now.beginning_of_day - 1.day + 6.hours }
    end

    trait :next_week do
      dtstart { Time.zone.now.beginning_of_day + 1.week + 4.hours }
      dtend { Time.zone.now.beginning_of_day + 1.week + 6.hours }
    end

    trait :last_week do
      dtstart { Time.zone.now.beginning_of_day - 1.week + 4.hours }
      dtend { Time.zone.now.beginning_of_day - 1.week + 6.hours }
    end

    trait :today_until_tomorrow do
      dtstart { Time.zone.now.beginning_of_day + 4.hours }
      dtend { Time.zone.now.beginning_of_day + 1.day }
    end
  end
end
