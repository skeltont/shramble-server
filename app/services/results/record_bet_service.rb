class Results::RecordBetService
  def initialize(player_id:, contestant_id:, match_id:)
    @player_id = player_id
    @contestant_id = contestant_id
    @match_id = match_id
  end

  def result
    @result ||= Result.find_or_create_by(
      player_id: @player_id,
      match_id: @match_id
    )
  end

  def record_bet
    if passed_on_round?
      result.pass_on_round
    elsif contestant_changed?
      result.set_contestant(@contestant_id)
    end

    result.save! if result.changed?
  end

  private

  def passed_on_round?
    result.pass && @contestant_id == 'pass'
  end

  def contestant_changed?
    result.contestant_id != @contestant_id
  end
end
