require "rails_helper"

RSpec.describe Api::SessionsController, type: :controller do
  context "creating a new session" do
    it "returns 200 OK when correct credentials are given" do
      user = create(:user)

      post :create, params: {email: user.email, password: user.password}

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["token"]).not_to be_empty
    end

    it "returns 401 UNAUTHORIZED when user does not exist" do
      post :create, params: {email: "some@email.com", password: "password"}

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq({"errors" => ["Invalid credentials"]})
    end

    it "returns 401 UNAUTHORIZED when password does not match" do
      user = create(:user, password: "some-password")

      post :create, params: {email: user.email, password: "other-password"}

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq({"errors" => ["Invalid credentials"]})
    end
  end
end
