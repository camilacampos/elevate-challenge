module Authentication
  ExpiredSignature = Class.new(StandardError)
  InvalidToken = Class.new(StandardError)

  extend ActiveSupport::Concern

  def encode_token(user, exp: 1.day.from_now)
    JWT.encode({ user_id: user.id, exp: exp.to_i }, ENV["JWT_SECRET"], "HS256")
  end

  def decode_token(token)
    JWT.decode(token, ENV["JWT_SECRET"])[0].with_indifferent_access
  rescue JWT::ExpiredSignature
    raise Authentication::ExpiredSignature
  rescue JWT::VerificationError
    raise Authentication::InvalidToken
  end
end
