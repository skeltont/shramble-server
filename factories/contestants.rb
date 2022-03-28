FactoryBot.define do
  factory :contestant do
    association :room
    association :matches

    sequence(:name) { |i| "contestant #{i}"}
  end
end
