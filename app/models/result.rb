class Result < ApplicationRecord
  belongs_to :player
  belongs_to :match
  belongs_to :contestant

  scope :with_matches, -> { joins(:match) }

  delegate :wager, to: :match

  def pass_on_round
    self.contestant_id = nil
    self.pass = true
  end

  def set_contestant(contestant_id)
    self.contestant_id = contestant_id
    self.pass = false
  end
end