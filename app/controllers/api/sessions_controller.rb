module Api
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user, only: [:create]

    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        render json: {token: encode_token(user)}
      else
        render json: {errors: ["Invalid credentials"]}, status: :unauthorized
      end
    end
  end
end
