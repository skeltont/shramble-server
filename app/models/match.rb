class Match < ApplicationRecord
  belongs_to :room
  has_many :match_contestants
  has_many :contestants, through: :match_contestants
  has_many :results

  scope :active, -> { where(stage: 'active') }

  def sorted_contestants
    self.contestants.sort_by(&:name)
  end
end
