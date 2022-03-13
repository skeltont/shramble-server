class MatchController < ApplicationController
  before_action :decode_token

  def create
    player = Player.find_by(id: @decoded[:player_id])
    render json: { 'error': 'you are not the owner' } unless player.owner

    match = Match.create!(room_id: @decoded[:room_id], wager: create_params[:stake])
    create_params[:contestants].each do |c|
      unless Contestant.find_by(name: c[:name])
        contestant = Contestant.create!(name: c[:name], room_id: @decoded[:room_id])
        MatchContestant.create!(match_id: match.id, contestant_id: contestant.id)
      end
    end
    room = Room.find_by(id: @decoded[:room_id])
    room.update_attribute(:stage, 'betting')
  end

  def start
    player = Player.find_by(id: @decoded[:player_id])
    render json: { 'error': 'you are not the owner' } unless player.owner

    @room = Room.find_by(id: @decoded[:room_id])
    @room.update_attribute(:stage, 'onging')
  end

  def end
    player = Player.find_by(id: @decoded[:player_id])
    render json: { 'error': 'you are not the owner' } unless player.owner

    match = Match.find_by(id: end_params[:match_id])
    match.update_attribute(:stage, 'inactive')

    Result.where(match_id: end_params[:match_id]).each do |result|
      if result.contestant_id == end_params[:contestant_id]
        result.update_attribute(:win, true)
      end
    end

    room = Room.find_by(id: @decoded[:room_id])
    room.update_attribute(:stage, 'results')
  end

  private

  def create_params
    params.require(:match).permit(:stake, contestants: [:name])
  end

  def start_params
    params.require(:match).permit(:match_id)
  end

  def end_params
    params.require(:match).permit(:match_id, :contestant_id)
  end
end
