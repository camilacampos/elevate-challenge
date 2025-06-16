require "rails_helper"

RSpec.describe RetrieveUserInfo do
  it "returns current user id and email" do
    user = double(User, id: 1, email: "email@example.com")

    result, err = described_class.new.call(user)

    expect(result[:id]).to eq user.id
    expect(result[:email]).to eq user.email
    expect(err).to be_nil
  end
end
