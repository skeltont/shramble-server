class Player < ApplicationRecord
  belongs_to :room
  has_many :result

  def winnings
    results = Result.joins(:match).where(player_id: self.id)
    results.sum(0.0) { |r| r.win ? r.match.wager : -r.match.wager }.to_d
  end
end