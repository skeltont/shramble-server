class Match < ApplicationRecord
  belongs_to :room
  has_many :contestants
  has_many :results
end