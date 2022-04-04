class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_#{params[:room_code]}"
  end
end
