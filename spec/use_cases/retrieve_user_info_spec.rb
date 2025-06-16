require "rails_helper"

RSpec.describe RetrieveUserInfo do
  it "returns current user info" do
    games = [double(Game), double(Game)]
    user = double(User, id: 1, email: "email@example.com")

    allow(user).to receive(:games).and_return(games)

    result, err = described_class.new.call(user)

    expect(result[:id]).to eq user.id
    expect(result[:email]).to eq user.email
    expect(result[:stats][:total_games_played]).to eq games.count
    expect(err).to be_nil
  end
end
