class RetrieveUserInfo
  def call(user)
    info = {
      id: user.id,
      email: user.email,
      stats: {total_games_played: user.games.count}
    }

    [info, nil]
  end
end
