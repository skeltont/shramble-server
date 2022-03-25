class RoomController < ApplicationController
  before_action :decode_token, except: :create
  before_action :process_recaptcha

  def create
    @room = Room.create!
    @player = Player.create!(name: create_params[:player_name], room_id: @room.id, owner: true)
    @token = generate_token(@player.id, @room.id)
  end

  def join
    @room = Room.find_by(room_code: join_params[:room_code])

    begin
      @player = Player.find_by(id: @decoded[:player_id], room_id: @room.id)
      @player.update_attribute(:name, join_params[:player_name])
    rescue NoMethodError, ActiveRecord::RecordNotFound => e
      @player = Player.create!(name: join_params[:player_name], room_id: @room.id)
      @token = generate_token(@player.id, @room.id)
    end
  end

  def index
    @room = Room.find_by(id: @decoded[:room_id])
  end

  private

  def process_recaptcha
    unless verify_recaptcha(response: params[:room][:recaptcha_token])
      render :json => { :error => 'invalid/missing recaptcha' }, :status => 403
    end
  end

  def generate_token(player_id, room_id)
    JsonWebToken.encode({player_id: player_id, room_id: room_id})
  end

  def create_params
    params.require(:room).permit(:player_name, :recaptcha_token)
  end

  def join_params
    params.require(:room).permit(:player_name, :room_code, :recaptcha_token)
  end
end
