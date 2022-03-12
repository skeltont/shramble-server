# some simple values to walk-through functionality

room = Room.create(room_code: 'abcde')

matches = Match.create([
  { room_id: room.id, wager: 2.0 },
  { room_id: room.id, wager: 2.0 },
  { room_id: room.id, wager: 2.5 },
  { room_id: room.id, wager: 5.0 },
])

alice = Player.create(room_id: room.id, name: 'Alice')
bob = Player.create(room_id: room.id, name: 'Bob')
carol = Player.create(room_id: room.id, name: 'Carol')

spartacus = Contestant.create(room_id: room.id, name: 'Spartacus')
crixus = Contestant.create(room_id: room.id, name: 'Crixus')
gannicus = Contestant.create(room_id: room.id, name: 'Gannicus')
oenomaus = Contestant.create(room_id: room.id, name: 'Oenomaus')

Result.create([
  # Spartacus win
  { player_id: alice.id, contestant_id: spartacus.id, match_id: matches.first.id, win: true },
  { player_id: bob.id, contestant_id: gannicus.id, match_id: matches.first.id },
  { player_id: carol.id, contestant_id: oenomaus.id, match_id: matches.first.id },

  # Crixus win
  { player_id: alice.id, contestant_id: spartacus.id, match_id: matches.second.id },
  { player_id: bob.id, contestant_id: crixus.id, match_id: matches.second.id, win: true },
  { player_id: carol.id, contestant_id: crixus.id, match_id: matches.second.id, win: true },

  # Oenomaus win
  { player_id: alice.id, contestant_id: spartacus.id, match_id: matches.third.id },
  { player_id: bob.id, contestant_id: crixus.id, match_id: matches.third.id },
  { player_id: carol.id, contestant_id: oenomaus.id, match_id: matches.third.id, win: true },

  # Spartacus win
  { player_id: alice.id, contestant_id: spartacus.id, match_id: matches.fourth.id, win: true },
  { player_id: bob.id, contestant_id: gannicus.id, match_id: matches.fourth.id },
  { player_id: carol.id, contestant_id: oenomaus.id, match_id: matches.fourth.id },
])