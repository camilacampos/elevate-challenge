class CompleteGame
  InvalidRequest = Class.new(StandardError)

  class CompleteGameContract < Dry::Validation::Contract
    params do
      required(:game_name).filled(::Types::DowncasedStrippedString)
      required(:type).value(::Types::UpcasedString, included_in?: ["COMPLETED"])
      required(:occurred_at).value(:date_time)
    end
  end

  def call(user, params)
    sanitezed_params, errors = validate_params(params)
    return [nil, errors] unless errors.empty?

    game = Game.find_or_create_by(name: sanitezed_params[:game_name])
    game_event = GameEvent.create!(
      user:, game:,
      event_type: sanitezed_params[:type],
      occurred_at: sanitezed_params[:occurred_at]
    )

    [game_event, nil] # no errors
  end

  private

  def validate_params(params)
    result = CompleteGameContract.new.call(params)
    errors = result.errors(full: true).to_h

    [result.to_h, errors.values.flatten]
  end
end
