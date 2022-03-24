class ResultController < ApplicationController
  before_action :decode_token

  def create
    bet = Results::RecordBetService.new(
      player_id: @decoded[:player_id],
      **create_params.to_h.symbolize_keys
    )
    bet.record_bet
    @result = bet.result
  end

  def index
    @presenter = Results::OngoingRoundPresenter.new(room_id: @decoded[:room_id])
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
