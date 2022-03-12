class Result < ApplicationRecord
  belongs_to :player
  belongs_to :match
  belongs_to :contestant
end