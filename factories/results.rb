FactoryBot.define do
  factory :result do
    association :match
    association :player
    association :contestant

    win { false }
    pass { false }
  end
end
