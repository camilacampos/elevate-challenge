require "rails_helper"

RSpec.describe RetrieveUserInfo do
  it "returns current user info" do
    games = [double(Game), double(Game)]
    user = instance_double(User, id: 1, email: "email@example.com")
    billing_api = instance_double(Billing::Api)
    status = "active"

    allow(user).to receive(:games).and_return(games)
    allow(billing_api).to receive(:get_subscription_status).with(user.id).and_return(status)

    result, err = described_class.new(billing_api:).call(user)

    expect(result[:id]).to eq user.id
    expect(result[:email]).to eq user.email
    expect(result[:stats][:total_games_played]).to eq games.count
    expect(result[:subscription_status]).to eq status
    expect(err).to be_nil
  end

  it "returns error when subscription status could not be retrieved" do
    games = [double(Game), double(Game)]
    user = instance_double(User, id: 1, email: "email@example.com")
    billing_api = instance_double(Billing::Api)
    error = HttpError.new("not working...", 500)


    allow(user).to receive(:games).and_return(games)
    allow(billing_api).to receive(:get_subscription_status).with(user.id).and_raise(error)

    result, err = described_class.new(billing_api:).call(user)

    expect(result).to be_nil
    expect(err).to eq([error.message])
  end
end
