class RetrieveUserInfo
  def initialize(billing_api: Billing::Api.new)
    @billing_api = billing_api
  end

  def call(user)
    status, err = retrieve_subscription_status(user)
    return [nil, err] if err

    info = {
      id: user.id,
      email: user.email,
      stats: {total_games_played: user.games.count},
      subscription_status: status
    }

    [info, nil]
  end

  private

  def retrieve_subscription_status(user)
    status = @billing_api.get_subscription_status(user.id)
    [status, nil]
  rescue HttpError => e
    [nil, [e.message]]
  end
end
