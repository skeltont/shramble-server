class Contestant < ApplicationRecord
  belongs_to :room
  has_many :result
end