class MatchContestant < ApplicationRecord
  belongs_to :match
  belongs_to :contestant
end