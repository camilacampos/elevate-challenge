module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate_user, only: [:create]

    def create
      user = User.new(user_params)

      if user.save
        head :created
      else
        render json: {
          errors: user.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.permit(:email, :password)
    end
  end
end
