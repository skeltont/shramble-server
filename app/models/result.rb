class Result < ApplicationRecord
  belongs_to :player
  belongs_to :match
  belongs_to :contestant

  scope :with_matches, -> { joins(:match) }

  delegate :wager, to: :match
end