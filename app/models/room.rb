class Room < ApplicationRecord
  has_many :player
  has_many :match

  # @TODO(Ty): consider changing 'room_code' to 'code'

  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    self.room_code ||= SecureRandom.hex.to_s[0, 8].upcase
  end
end