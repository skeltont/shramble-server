class Results::OngoingRoundPresenter
  def initialize(room_id:)
    @room_id = room_id
  end

  def match
    @match ||= Match.find_by(room_id: room.id, stage: 'active')
  end

  def results
    Result.where(match_id: match.id).sort_by { |r| r.player.name }
  end

  def contestants
    match.sorted_contestants
  end

  private

  def room
    @room ||= Room.find(@room_id)
  end
end
