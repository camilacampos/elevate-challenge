module Billing
  class Api
    def initialize(http_request_class: HttpRequest)
      @http_request = http_request_class.new(
        api_token: ENV["BILLING_SERVICE_TOKEN"],
        base_path: "https://interviews-accounts.elevateapp.com/api/v1/"
      )
    end

    def get_subscription_status(user_id)
      result = @http_request.get("users/#{user_id}/billing")

      JSON.parse(result.body)["subscription_status"]
    end
  end
end
