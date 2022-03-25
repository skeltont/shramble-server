class ResultController < ApplicationController
  before_action :decode_token

  def create
    @presenter = Results::RecordBetPresenter.new(
      player_id: @decoded[:player_id],
      **create_params.to_h.symbolize_keys
    )
    @presenter.record_bet
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
