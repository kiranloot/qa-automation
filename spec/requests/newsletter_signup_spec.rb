require 'spec_helper'

describe "A visitor signs up for mailing list" do

  describe "sign up with correct email" do
    it "returns 200" do
      allow_any_instance_of(Friendbuy::API).to receive(:get_PURL)
      expect_any_instance_of(Sailthru::Client).to receive(:api_post)
      post newsletter_signup_path, email: 'jeffects@mailinator.com'
      expect(response.body)
    end
  end
end
