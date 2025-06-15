module AuthenticationHelper
  def signin(user, exp: 1.day.from_now)
    token = JWT.encode({user_id: user.id, exp: exp.to_i}, ENV["JWT_SECRET"], "HS256")

    request.headers["Authorization"] = "Bearer #{token}"
  end
end
