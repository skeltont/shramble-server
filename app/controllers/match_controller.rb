class MatchController < ApplicationController
  before_action :decode_token
  before_action :authorize

  def new
    room = Room.find(@decoded[:room_id])
    room.update_attribute(:stage, 'pending')

    broadcast_stage(room.room_code, 'pending')
  end

  def create
    room = Room.find(@decoded[:room_id])
    room.update_attribute(:stage, 'betting')

    match = Match.create!(room_id: room.id, wager: create_params[:stake])
    create_params[:contestants].each do |c|
      unless Contestant.find_by(room_id: room.id, name: c[:name])
        contestant = Contestant.create!(name: c[:name], room_id: room.id)
      end

      MatchContestant.create!(match_id: match.id, contestant_id: contestant.id)
    end

    broadcast_stage(room.room_code, 'betting')
  end

  def start
    room = Room.find(@decoded[:room_id])
    room.update!(stage: 'ongoing')

    broadcast_stage(room.room_code, 'ongoing')
  end

  def end
    room = Room.find(@decoded[:room_id])
    room.update_attribute(:stage, 'results')

    match = Match.find_by(id: end_params[:match_id])
    match.update_attribute(:stage, 'inactive')

    results = Result.with_matches.where(match_id: match.id)

    results.each do |result|
      if result.contestant_id == end_params[:contestant_id]
        result.update_attribute(:win, true)
      end
    end

    match.calculate_winnings

    broadcast_stage(room.room_code, 'results')
  end

  private

  def broadcast_stage(room_code, stage)
    ActionCable.server.broadcast("room_#{room_code}", { stage: stage })
  end

  def authorize
    player = Player.find_by(id: @decoded[:player_id])
    render json: { 'error': 'you are not the owner' }, :status => 403 unless player.owner
  end

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
