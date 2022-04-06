class Room < ApplicationRecord
  has_many :players
  has_many :matches
  has_many :contestants

  # @TODO(Ty): consider changing 'room_code' to 'code'

  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    self.room_code ||= SecureRandom.hex.to_s[0, 8].upcase
  end

  def active_match
    matches.where(stage: 'active').first
  end
end
