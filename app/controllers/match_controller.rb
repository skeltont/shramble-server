class MatchController < ApplicationController
  before_action :decode_token

  def create
    player = Player.find_by(id: @decoded[:player_id])
    render json: { 'error': 'you are not the owner' } unless player.owner

    match = Match.create!(room_id: @decoded[:room_id], wager: create_params[:stake])
    create_params[:contestants].each do |contestant|
      unless Contestant.find_by(name: contestant[:name])
        Contestant.create!(name: contestant[:name], room_id: @decoded[:room_id])
      end
    end
    room = Room.find_by(id: @decoded[:room_id])
    room.update_attribute(:state, 'betting')
  end

  private

  def create_params
    params.require(:match).permit(:stake, contestants: [:name])
  end
end
