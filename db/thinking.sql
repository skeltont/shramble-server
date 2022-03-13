-- potential way to query wins and losses?
select
  p.id,
  p.name,
  SUM(case when r.win then m.wager end) as winnings,
  SUM(case when not r.win then m.wager end) as losses
  from results as r
  join players as p on r.player_id = p.id
  join matches as m on r.match_id = m.id
  where p.id='3c3df643-c3fc-4502-af40-44398476bcfc' -- example
  group by p.id;