FactoryBot.define do
  factory :player do
    association :room

    sequence(:name) { |i| "player #{i}"}

    trait :with_bet do
      transient do
        contestant { nil }
      end

      after(:create) do |player, evaluator|
        FactoryBot.create(
          :result,
          match: player.room.active_match,
          player: player,
          contestant: evaluator.contestant
        )
      end
    end
  end
end
