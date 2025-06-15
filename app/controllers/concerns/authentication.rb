module Authentication
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods

  ExpiredSignature = Class.new(StandardError)
  InvalidToken = Class.new(StandardError)
  NotAuthorized = Class.new(StandardError)

  included do
    before_action :authenticate_user
  end

  def authenticate_user
    @current_user = authenticate_with_http_token do |token, _|
      decoded_token = decode_token(token)
      User.find(decoded_token[:user_id])
    end
    raise Authentication::NotAuthorized unless @current_user
  end

  def current_user
    @current_user
  end

  def encode_token(user, exp: 1.day.from_now)
    JWT.encode({user_id: user.id, exp: exp.to_i}, ENV["JWT_SECRET"], "HS256")
  end

  def decode_token(token)
    JWT.decode(token, ENV["JWT_SECRET"])[0].with_indifferent_access
  rescue JWT::ExpiredSignature
    raise Authentication::ExpiredSignature
  rescue JWT::VerificationError
    raise Authentication::InvalidToken
  end
end
