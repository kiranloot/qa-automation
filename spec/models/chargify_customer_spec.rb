require 'spec_helper'

describe ChargifyCustomer, type: :model do
  let(:customer) { build(:chargify_customer_account) }

  describe "Associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "Validations" do
    it { validate_uniqueness_of(:chargify_customer_id) }
  end

  describe "#destroy_if_homeless" do
    context "when there are subscriptions belonging to chargify customer" do
      before do
        create(:subscription, customer_id: customer.chargify_customer_id)
      end

      it "does not delete chargify customer" do
        expect{
          customer.destroy_if_homeless
        }.to_not change(ChargifyCustomer, :count)
      end
    end

    context "when there are NO subscriptions belonging to chargify customer" do
      before { create(:subscription) }

      it "deletes chargify customer" do
        customer.save

        expect{
          customer.destroy_if_homeless
        }.to change(ChargifyCustomer, :count).by(-1)
      end
    end
  end
end
