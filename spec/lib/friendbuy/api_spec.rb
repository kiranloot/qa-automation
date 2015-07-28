require 'spec_helper'

describe Friendbuy::API do
  let(:fb_api) do
    Friendbuy::API.new customer_id: '78', campaign_id: 13099
  end

  describe 'constants' do
    subject { Friendbuy::API }

    it { is_expected.to have_constant(:BASE_URI) }
    it { is_expected.to have_constant(:LOOTCRATE_SHORTEN_DOMAIN) }
    it { is_expected.to have_constant(:CREDENTIALS) }
  end

  describe "#post_conversion(data)" do
    let(:subscription) { create(:subscription) }
    let(:user) { subscription.user }
    let(:conversion_data) do
      {
        order: { id: subscription.id.to_s, amount: subscription.plan.cost },
        referral_code: "bJRJ9",
        customer: { id: user.email },
        products: [
          { sku: subscription.plan.name, price: subscription.plan.cost, quantity: 1}
        ]
      }
    end

    it "returns 201 CREATED response code" do
      VCR.use_cassette 'friendbuy/purchases_success' do
        response = fb_api.post_conversion conversion_data

        expect(response.code).to eq 201
      end
    end
  end

  describe "#get_PURL" do
    context "with valid parameters" do
      it "returns personal URL" do
        VCR.use_cassette 'friendbuy/success_referral_code' do
          result = fb_api.get_PURL

          expect(result).to eq 'http://fbuy.me/bQR-q'
        end
      end
    end

    context "with invalid parameters" do
      let(:fb_api) { Friendbuy::API.new }

      it "returns nil" do
        VCR.use_cassette 'friendbuy/failed_referral_code' do
          result = fb_api.get_PURL

          expect(result).to eq nil
        end
      end
    end
  end
end