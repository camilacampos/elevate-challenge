require "rails_helper"

RSpec.describe Billing::Api do
  it "fetches the subscription status for the user" do
    user_id = 123
    response = {subscription_status: "active"}
    http_response = instance_double("Typhoeus::Response", body: response.to_json)
    http_request_instance = instance_double(HttpRequest)
    http_request_class = class_double(HttpRequest, new: http_request_instance)

    allow(http_request_instance).to receive(:get).with("users/#{user_id}/billing").and_return(http_response)

    result = described_class.new(
      http_request_class:
    ).get_subscription_status(user_id)

    expect(result).to eq("active")
  end

  it "raises error when request fails" do
    user_id = 123
    response = {error: "Service Unavailable"}
    instance_double("Typhoeus::Response", body: response.to_json, code: 503)
    error = HttpError.new("Service Unavailable", 503)
    http_request_instance = instance_double(HttpRequest)
    http_request_class = class_double(HttpRequest, new: http_request_instance)

    allow(http_request_instance).to receive(:get).with("users/#{user_id}/billing").and_raise(error)

    api = described_class.new(http_request_class:)

    expect { api.get_subscription_status(user_id) }.to raise_error(error) do |err|
      expect(err.message).to eq(error.message)
      expect(err.status).to eq(error.status)
    end
  end
end
