FactoryBot.define do
  factory :game_event do
    association :user
    association :game
    event_type { "COMPLETED" }
    occurred_at { DateTime.now }
  end
end
