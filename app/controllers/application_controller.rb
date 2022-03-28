class ApplicationController < ActionController::API
  def not_found
    render json: { error: 'not_found' }
  end

  def self.generate_token(player_id, room_id)
    JsonWebToken.encode({player_id: player_id, room_id: room_id})
  end

  def decode_token
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      @decoded = JsonWebToken.decode(header).symbolize_keys
    rescue JWT::DecodeError => e
      @decoded = nil
    end
  end
end
