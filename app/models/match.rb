class Match < ApplicationRecord
  belongs_to :room
  has_many :contestant, through: :match_contestant
  has_many :result
end