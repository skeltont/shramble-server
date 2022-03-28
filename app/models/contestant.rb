class Contestant < ApplicationRecord
  belongs_to :room
  has_many :match_contestants
  has_many :matches, through: :match_contestants
  has_many :results
end
