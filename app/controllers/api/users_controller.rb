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

    def show
      user_info, _ = RetrieveUserInfo.new.call(current_user)

      render json: {user: user_info}
    end

    def game_events
      _, err = CompleteGame.new.call(current_user, game_event_params.to_h)

      if err
        render json: {
          errors: err
        }, status: :unprocessable_entity
      else
        head :created
      end
    end

    private

    def user_params
      params.permit(:email, :password)
    end

    def game_event_params
      params.require(:game_event).permit(:game_name, :type, :occurred_at)
    end
  end
end
