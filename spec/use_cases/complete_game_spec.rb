require "rails_helper"

RSpec.describe CompleteGame do
  context "contract validations" do
    it "normalizes name" do
      game_name = "   GAMe    naME   "
      expected_name = "game name"

      result = CompleteGame::CompleteGameContract.new.call(game_name:)

      expect(result.to_h[:game_name]).to eq expected_name
      expect(result.errors.to_h[:game_name]).to be_nil
    end

    it "normalizes type" do
      accepted_types = ["completed", "COMPLETED", "CoMpLeTeD"]
      expected_type = "COMPLETED"

      aggregate_failures do
        accepted_types.each do |type|
          result = CompleteGame::CompleteGameContract.new.call(type:)

          expect(result.to_h[:type]).to eq expected_type
          expect(result.errors.to_h[:type]).to be_nil
        end
      end
    end

    it "normalizes occurred_at" do
      accepted_values = ["2025-01-01T00:00:00.000Z", DateTime.parse("2025-01-01T00:00:00.000Z")]
      expected_value = DateTime.parse("2025-01-01T00:00:00.000Z")

      aggregate_failures do
        accepted_values.each do |occurred_at|
          result = CompleteGame::CompleteGameContract.new.call(occurred_at:)

          expect(result.to_h[:occurred_at]).to eq expected_value
          expect(result.errors.to_h[:occurred_at]).to be_nil
        end
      end
    end
  end

  it "returns error for invalid params" do
    test_cases = [
      # name, type, occurred_at, valid, error
      [nil, "COMPLETED", "2025-01-01T00:00:00.000Z", "game_name must be filled"],
      ["Brevity", nil, "2025-01-01T00:00:00.000Z", "type must be a string"],
      ["Brevity", "COMPLETED", nil, "occurred_at must be a date time"],
      ["Brevity", "COMPLETED", "invalid-date", "occurred_at must be a date time"]
    ]
    user = double("user")

    aggregate_failures do
      test_cases.each do |test|
        params = {
          game_name: test[0],
          type: test[1],
          occurred_at: test[2]
        }
        result, err = described_class.new.call(user, params)

        expect(result).to be_nil
        expect(err).to eq([test[3]])
      end
    end
  end

  it "creates new game and game event when game does not exist" do
    params = {
      game_name: "Brevity",
      type: "completed",
      occurred_at: "2025-01-01T00:00:00.000Z"
    }
    user = create(:user)
    result, err = nil, nil

    expect {
      result, err = described_class.new.call(user, params)
    }.to change(Game, :count).by(1)
      .and change(GameEvent, :count).by(1)

    expect(result).not_to be_nil
    expect(err).to be_nil
    user.reload
    expect(user.game_events).to include(result)
  end

  it "uses existing game and create new game event when game already exists" do
    params = {
      game_name: "brevity",
      type: "completed",
      occurred_at: "2025-01-01T00:00:00.000Z"
    }
    create(:game, name: params[:game_name])
    user = create(:user)
    result, err = nil, nil

    expect {
      result, err = described_class.new.call(user, params)
    }.to change(Game, :count).by(0)
      .and change(GameEvent, :count).by(1)

    expect(result).not_to be_nil
    expect(err).to be_nil
    user.reload
    expect(user.game_events).to include(result)
  end
end
