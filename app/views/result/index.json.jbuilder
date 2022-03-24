json.results @presenter.results do |result|
  json.name result.player.name
  json.bet result.bet
end
json.contestants @presenter.contestants do |contestant|
  json.id contestant.id
  json.name contestant.name
end
json.match_id @presenter.match.id
