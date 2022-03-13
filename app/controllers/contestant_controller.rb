class ContestantController < ApplicationController
  before_action :decode_token

  def index
    room = Room.find(@decoded[:room_id])
    @match = Match.active.find_by(room_id: room.id)
    @contestants = MatchContestant.where(match_id: @match.id).map(&:contestant)
  end
end
