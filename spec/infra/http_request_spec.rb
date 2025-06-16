require "rails_helper"

RSpec.describe HttpRequest do
  let(:base_path) { "base.url" }
  let(:api_token) { "api-token" }
  let(:headers) { {"Authorization" => "Bearer #{api_token}"} }

  it "returns response if request is successful" do
    http_client = class_double(Typhoeus::Request)
    request = instance_double(Typhoeus::Request)
    response = instance_double(Typhoeus::Response, success?: true)
    subject = described_class.new(
      api_token: api_token,
      base_path: base_path,
      http_client: http_client
    )
    path = "any_path"
    full_url = "#{base_path}/#{path}"
    params = {some: "params"}

    allow(http_client).to receive(:new).with(full_url, params:, headers:).and_return(request)
    allow(request).to receive(:on_complete).and_yield(response)
    allow(request).to receive(:run).and_return(response)

    result = subject.get(path, params)

    expect(result).to eq response
  end

  it "raises HttpError if request is not successful" do
    http_client = class_double(Typhoeus::Request)
    request = instance_double(Typhoeus::Request)
    response = instance_double(Typhoeus::Response, success?: false, code: 503, body: {error: "Some Error"}.to_json)
    subject = described_class.new(
      api_token: api_token,
      base_path: base_path,
      http_client: http_client
    )
    path = "any_path"
    full_url = "#{base_path}/#{path}"
    params = {some: "params"}

    allow(http_client).to receive(:new).with(full_url, params:, headers:).and_return(request)
    allow(request).to receive(:on_complete).and_yield(response)

    expect { subject.get(path, params) }.to raise_error(HttpError) do |error|
      expect(error.message).to eq("Some Error")
      expect(error.status).to eq(503)
    end
  end
end
