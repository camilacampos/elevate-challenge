class RetrieveUserInfo
  def call(user)
    info = {
      id: user.id,
      email: user.email
    }

    [info, nil]
  end
end
