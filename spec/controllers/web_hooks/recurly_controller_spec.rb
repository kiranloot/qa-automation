require 'spec_helper'

RSpec.describe WebHooks::RecurlyController do
  include AuthHelper
  let(:raw_post) do
    {
      "notification" => {
        "subscription" => {
          "uuid" => '1a'
        }
      }
    }.to_xml
  end

  before do
    http_login
  end

  context "when it is successful" do
    it "renders nothing" do
      allow_any_instance_of(WebHooksHandler::Recurly).to receive(:handle) { true }

      post :dispatcher, raw_post

      expect(response.body).to be_blank
    end
  end

  context "when it fails" do
    it "renders nothing with a status 422" do
      allow_any_instance_of(WebHooksHandler::Recurly).to receive(:handle) { false }

      post :dispatcher, raw_post

      expect(response.body).to be_blank
      expect(response.status).to eq 422
    end
  end
end