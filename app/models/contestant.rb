class Contestant < ApplicationRecord
  belongs_to :room
  has_many :match, through: :match_contestant
  has_many :result
end