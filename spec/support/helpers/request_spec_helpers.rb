module RequestSpecHelpers
  def authenticate player, room
    return ApplicationController.generate_token(player.id, room.id)
  end

  def response_json
    @response_json ||= JSON.parse(response.body, symbolize_names: true)
  end
end
