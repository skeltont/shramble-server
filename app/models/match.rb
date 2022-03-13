class Match < ApplicationRecord
  belongs_to :room
  has_many :contestants, through: :match_contestant
  has_many :results

  scope :active, -> { where(stage: 'active') }
end