module Api
  class SessionsController < ApplicationController
    include Authentication

    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        render json: { token: encode_token(user) }
      else
        render json: { errors: [ "Invalid credentials" ] }, status: :unauthorized
      end
    end
  end
end
