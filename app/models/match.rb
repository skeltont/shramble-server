class Match < ApplicationRecord
  belongs_to :room
  has_many :match_contestants
  has_many :contestants, through: :match_contestants
  has_many :results

  scope :active, -> { where(stage: 'active') }

  def self.deactivate_all_for_room(room_id)
    where(room_id: room_id, stage: 'active').update!(stage: 'inactive')
  end

  def sorted_contestants
    self.contestants.sort_by(&:name)
  end

  def calculate_winnings
    if self.results.any?(&:win?)
      self.update_attribute(:winnings, self.results.sum(&:wager) / self.results.count(&:win?))
    end
  end
end
