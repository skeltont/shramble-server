json.room_id @room.id
json.room_code @room.room_code
json.stage @room.stage
json.token @token unless @decoded
json.owner @player.owner
