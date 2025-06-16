require "rails_helper"

RSpec.describe User, type: :model do
  it "validates user" do
    test_cases = [
      # email, password, valid, error messages
      ["email@example.com", "password", true, nil],
      ["invalid.email", "password", false, "Email is invalid"],
      [nil, "password", false, "Email can't be blank"], # no email
      ["email@example.com", "pass", false, "Password is too short (minimum is 6 characters)"],
      ["email@example.com", nil, false, "Password can't be blank"] # no password
    ]

    aggregate_failures do
      test_cases.each do |test|
        user = User.new(email: test[0], password: test[1])

        expect(user.valid?).to eq(test[2])
        if test[3]
          expect(user.errors.full_messages).to include(test[3])
        else
          expect(user.errors).to be_empty
        end
      end
    end
  end

  it "normalizes email" do
    test_cases = [
      # given, expected
      ["email@example.com", "email@example.com"],
      ["  email   @example .com ", "email@example.com"],
      ["EMAIL@EXampLE.COM", "email@example.com"]
    ]

    aggregate_failures do
      test_cases.each do |test|
        user = User.new(email: test[0], password: "some-password")

        expect(user.email).to eq(test[1])
      end
    end
  end

  it "validates email uniqueness" do
    email = "email@example.com"
    create(:user, email:)

    user = User.new(email:, password: "password")

    expect(user).not_to be_valid
    expect(user.errors.full_messages).to include("Email has already been taken")
  end

  it "retrieves all user games (distinct)" do
    user = create(:user)
    game1 = create(:game)
    game2 = create(:game)
    game_event1 = create(:game_event, user:, game: game1)
    game_event2 = create(:game_event, user:, game: game1)
    game_event3 = create(:game_event, user:, game: game2)

    expect(user.games.count).to eq 2
    expect(user.games).to contain_exactly(game1, game2)
  end
end
