class ContestantController < ApplicationController
  before_action :decode_token

  def index
    room = Room.find_by(id: @decoded[:room_id])
    @match = Match.find_by(room_id: room.id, stage: 'active')
    @contestants = MatchContestant.where(match_id: @match.id).map(&:contestant)
  end
end
