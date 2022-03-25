FactoryBot.define do
  factory :player do
    association :room

    sequence(:name) { |i| "player #{i}"}
  end
end
