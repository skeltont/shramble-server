class Contestant < ApplicationRecord
  belongs_to :room
  has_many :matches, through: :match_contestant
  has_many :results
end