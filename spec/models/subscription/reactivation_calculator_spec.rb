require 'spec_helper'

describe Subscription::ReactivationCalculator do
  let(:data) do
    instance_double(Subscription::ReactivationData,
      current_plan_cost: 19.95,
      current_plan_name: '3-month-subscription',
      shipping_address_zip: '91733'
    )
  end
  let(:calculator) { Subscription::ReactivationCalculator.new(data) }
  let(:tax_retriever) { instance_double(TaxRetriever) }

  describe "#preview" do
    before { allow(TaxRetriever).to receive(:new) { tax_retriever } }

    it "returns a hash with data on subscription's reactivation" do
      tax_info = { tax_amount: 0 }
      allow(data).to receive(:coupon_amount) { 0 }
      allow(tax_retriever).to receive(:get_tax_details) { tax_info }
      information_keys = [:total_payment, :amount_saved, :plan_name]

      preview = calculator.preview

      expect(preview).to be_a Hash
      expect(preview.keys).to match_array information_keys
    end

    it "adjusts total_payment when a coupon_amount is applied" do
      tax_info = { tax_amount: 0 }
      allow(data).to receive(:coupon_amount) { 2 }
      allow(tax_retriever).to receive(:get_tax_details) { tax_info }
      expected_payment = data.current_plan_cost - data.coupon_amount

      preview          = calculator.preview

      expect(preview[:total_payment]).to eq expected_payment
    end

    it "adjusts total_payment when tax is applied" do
      tax_info = { tax_amount: 1 }
      allow(data).to receive(:coupon_amount) { 0 }
      allow(tax_retriever).to receive(:get_tax_details) { tax_info }
      expected_payment = data.current_plan_cost + tax_info[:tax_amount]

      preview = calculator.preview

      expect(preview[:total_payment]).to eq expected_payment
    end

    it 'adjust total_payment when tax is applied with a valid coupon' do
      tax_info = { tax_amount: 1 }
      allow(data).to receive(:coupon_amount) { 2 }
      allow(tax_retriever).to receive(:get_tax_details) { tax_info }
      expected_payment = data.current_plan_cost - data.coupon_amount + tax_info[:tax_amount]

      preview = calculator.preview

      expect(preview[:total_payment]).to eq expected_payment
    end
  end
end