FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@example.com" }
    password { SecureRandom.hex(10) }

    trait :with_game_event do
      transient do
        game_events_count { 1 }
      end
      after(:create) do |user, evaluator|
        create_list(:game_event, evaluator.game_events_count, user: user)
      end
    end
  end
end
