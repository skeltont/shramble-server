class ContestantController < ApplicationController
  before_action :decode_token

  def index
    room = Room.find(@decoded[:room_id])
    @match = room.active_match
    @contestants = @match.sorted_contestants
  end
end
