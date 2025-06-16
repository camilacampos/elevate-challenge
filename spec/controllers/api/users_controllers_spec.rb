require "rails_helper"

RSpec.describe Api::UsersController, :vcr, type: :controller do
  context "creating a new user" do
    it "returns 201 CREATED when params are correct" do
      expect {
        post :create, params: {email: "email@example.com", password: "password"}
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "returns 422 when user already exists" do
      email = "email@example.com"
      create(:user, email:)

      expect {
        post :create, params: {email:, password: "password"}
      }.to change(User, :count).by(0)

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body).to eq({"errors" => ["Email has already been taken"]})
    end

    it "returns 422 when there are validation errors" do
      expect {
        post :create, params: {email: "invalid-email", password: "pass"}
      }.to change(User, :count).by(0)

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body).to eq({"errors" => ["Email is invalid", "Password is too short (minimum is 6 characters)"]})
    end
  end

  context "showing current user info" do
    it "returns 200 OK with logged user info" do
      user = create(:user, :with_game_event, game_events_count: 2)
      signin(user)

      get :show

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["user"]).to match({
        "id" => user.id,
        "email" => user.email,
        "stats" => {
          "total_games_played" => 2
        },
        "subscription_status" => "expired"
      })
    end

    it "returns 422 when billing service is unavailable" do
      user = create(:user, :with_game_event, game_events_count: 2, id: 5)
      signin(user)

      get :show

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body["errors"]).to include("Service temporarily unavailable")
    end

    it "returns 422 when billing service does not find user" do
      user = create(:user, :with_game_event, game_events_count: 2, id: 105)
      signin(user)

      get :show

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body["errors"]).to include("User not found")
    end

    it "returns 401 UNAUTHORIZED for unlogged users" do
      get :show

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end

  context "creating a new game event" do
    it "returns 201 CREATED when all params are correct" do
      user = create(:user)
      game = create(:game)
      signin(user)

      params = {
        game_event: {
          game_name: game.name,
          type: "COMPLETED",
          occurred_at: "2025-01-01T00:00:00.000Z"
        }
      }

      post :game_events, params: params

      expect(response).to have_http_status(:created)
      expect(response.body).to be_empty
    end

    it "returns 422 UNPROCESSABLE ENTITY when there are validation errors" do
      user = create(:user)
      game = create(:game)
      signin(user)

      params = {
        game_event: {
          game_name: game.name,
          type: "STARTED",
          occurred_at: "2025-01-01T00:00:00.000Z"
        }
      }

      post :game_events, params: params

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body["errors"]).to include("type must be one of: COMPLETED")
    end

    it "returns 401 UNAUTHORIZED for unlogged users" do
      params = {
        game_event: {
          game_name: "game name",
          type: "COMPLETED",
          occurred_at: "2025-01-01T00:00:00.000Z"
        }
      }

      post :game_events, params: params

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
