FactoryBot.define do
  factory :match do
    association :room

    wager { 2.0 }
    winnings { 4.0 }
    stage { 'active' }

    trait :with_contestants do
      after(:create) do |match, evaluator|
        FactoryBot.create(:contestant, room: evaluator.room, name: 'contestant 1', matches: [match])
        FactoryBot.create(:contestant, room: evaluator.room, name: 'contestant 2', matches: [match])
      end
    end
  end
end
