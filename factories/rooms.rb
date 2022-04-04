FactoryBot.define do
  factory :room do
    room_code { SecureRandom.hex.to_s[0, 8].upcase }
  end

  trait :populated do
    after(:create) do |room|
      player_1 = FactoryBot.create(:player, room: room, name: 'player 1')
      player_2 = FactoryBot.create(:player, room: room, name: 'player 2')

      FactoryBot.create(:match, :with_contestants, room: room)

      FactoryBot.create(
        :result,
        match: room.active_match,
        player: player_1,
        contestant: room.active_match.sorted_contestants.first,
      )
      FactoryBot.create(
        :result,
        match: room.active_match,
        player: player_2,
        contestant: room.active_match.sorted_contestants.second,
      )
    end
  end
end
