class Player < ApplicationRecord
  belongs_to :room
  has_many :results

  def winnings
    Result.joins(:match).where(player_id: self.id).sum(0.0) do |r|
      (r.win ? r.match.winnings : 0) - (r.pass ? 0 : r.match.wager)
    end
  end
end
