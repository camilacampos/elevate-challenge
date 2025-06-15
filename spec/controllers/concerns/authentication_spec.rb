require "rails_helper"

RSpec.describe Authentication do
  let(:klass) do
    Class.new(ApplicationController) do
      include Authentication
    end
  end

  before { travel_to Time.now }
  after { travel_back }

  it "encodes and decodes token from user" do
    user = create(:user)
    fake_controller = klass.new

    token = fake_controller.encode_token(user)
    decoded_token = fake_controller.decode_token(token)

    expect(decoded_token).to match({
      user_id: user.id,
      exp: 1.day.from_now.to_i
    })
  end

  it "encodes and decodes token with custom expiration time" do
    user = create(:user)
    fake_controller = klass.new

    token = fake_controller.encode_token(user, exp: 2.days.from_now)
    decoded_token = fake_controller.decode_token(token)

    expect(decoded_token).to match({
      user_id: user.id,
      exp: 2.days.from_now.to_i
    })
  end

  it "raises error when token is expired" do
    user = create(:user)
    fake_controller = klass.new

    token = fake_controller.encode_token(user, exp: 1.day.from_now)

    travel 3.days

    expect {
      fake_controller.decode_token(token)
    }.to raise_error(Authentication::ExpiredSignature)
  end

  it "raises error when token is invalid" do
    fake_controller = klass.new

    # invalid token
    token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NTAyMTc3ODN9.Acyyy0hUhBtkxJipmMOzxkyC_40V9Pp06Cg8fZW9B-g"

    expect {
      fake_controller.decode_token(token)
    }.to raise_error(Authentication::InvalidToken)
  end
end
