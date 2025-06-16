class HttpRequest
  def initialize(api_token:, http_client: Typhoeus::Request, base_path: "")
    @http_client = http_client
    @base_path = base_path
    @api_token = api_token
  end

  def get(path, params = {})
    request = @http_client.new("#{@base_path}/#{path}", params:, headers: authorization_headers)
    request.on_complete do |resp|
      if resp.success?
        resp
      else
        msg = JSON.parse(resp.body)["error"]
        raise HttpError.new(msg, resp.code)
      end
    end
    request.run
  end

  private

  def authorization_headers
    {"Authorization" => "Bearer #{@api_token}"}
  end
end
