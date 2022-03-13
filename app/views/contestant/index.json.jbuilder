json.contestants @contestants do |contestant|
  json.id contestant.id
  json.name contestant.name
end
json.match_id @match.id