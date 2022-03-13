class ResultController < ApplicationController
  before_action :decode_token

  def create
    @result = Result.find_or_create_by(
      player_id: @decoded[:player_id],
      match_id: create_params[:match_id]
    )

    unless @result.contestant_id == create_params[:contestant_id]
      @result.update_attribute(:contestant_id, create_params[:contestant_id])
    end
  end

  def index
    room = Room.find(@decoded[:room_id])
    @match = Match.find_by(room_id: room.id, stage: 'active')
    @results = Result.where(match_id: @match.id)
    @contestants = MatchContestant.where(match_id: @match.id).map(&:contestant)
  end

  def standings
    room = Room.find(@decoded[:room_id])
    @players = room.players
  end

  private

  def create_params
    params.require(:result).permit(:match_id, :contestant_id)
  end
end