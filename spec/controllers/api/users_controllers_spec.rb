require "rails_helper"

RSpec.describe Api::UsersController, type: :controller do
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
      user = create(:user)
      signin(user)

      get :show

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to match({
        "user_id" => user.id,
        "user_email" => user.email
      })
    end

    it "returns 401 UNAUTHORIZED for unlogged users" do
      get :show

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
