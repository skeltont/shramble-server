json.results @results do |result|
  json.name result.player.name
  json.contestant result.contestant.name
end
json.contestants @contestants do |contestant|
  json.id contestant.id
  json.name contestant.name
end
json.match_id @match.id