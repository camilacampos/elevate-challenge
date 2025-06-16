require 'rails_helper'

RSpec.describe Game, type: :model do
  it "validates game" do
    test_cases = [
      # name, valid, error messages
      ["Cool Name", true, nil],
      [nil, false, "Name can't be blank"], # no name
    ]

    aggregate_failures do
      test_cases.each do |test|
        game = Game.new(name: test[0])

        expect(game.valid?).to eq(test[1])
        if test[2]
          expect(game.errors.full_messages).to include(test[2])
        else
          expect(game.errors).to be_empty
        end
      end
    end
  end

  it "normalizes name" do
    test_cases = [
      # given, expected
      ["Cool Name", "cool name"],
      ["cool name", "cool name"],
      ["   cOOl   nAMe  ", "cool name"]
    ]

    aggregate_failures do
      test_cases.each do |test|
        game = Game.new(name: test[0])

        expect(game.name).to eq(test[1])
      end
    end
  end

  it "validates name uniqueness" do
    name = "cool name"
    create(:game, name:)

    game = Game.new(name:)

    expect(game).not_to be_valid
    expect(game.errors.full_messages).to include("Name has already been taken")
  end

  it "returns human name titleized" do
    game = Game.new(name: "cool name")

    expect(game.human_name).to eq("Cool Name")
  end
end
