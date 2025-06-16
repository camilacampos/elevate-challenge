FactoryBot.define do
  factory :game do
    sequence(:name) { |n| "game #{n}" }
  end
end
