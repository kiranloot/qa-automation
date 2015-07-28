require 'spec_helper'

describe Subscription::CurrentUnit do
  let(:subscription) { FactoryGirl.create(:subscription) }
  let(:current_period) { create(:active_subscription_period, subscription: subscription) }

  after do
    Timecop.return
  end

  context "shipment exists for current month" do
    before do
      current_period.subscription_units.create(subscription_id: subscription.id,
                                             tracking_number: '1234',
                                             shipping_address: subscription.shipping_address.clone,
                                             service_code: 'usps_first_class_mail',
                                             month_year: 'FEB2015')
    end

    context "#editing before the end of the 19th" do
      it "finds the correct crate" do
        Timecop.freeze(2015, 2, 19)
        current_unit = Subscription::CurrentUnit.find(current_period)
        expect(current_unit).to be_equal(current_period.subscription_units.first)
      end
    end

    context "#editing after the 19th" do
      it "finds the correct crate" do
        Timecop.freeze(2015, 1, 20)
        current_unit = Subscription::CurrentUnit.find(current_period)
        expect(current_unit).to be_equal(current_period.subscription_units.first)
      end
    end
  end

  context "shipment does not exist for current month" do
    context "#editing before the end of the 19th" do
      it "finds the no crate" do
        Timecop.freeze(2015, 2, 19)
        current_unit = Subscription::CurrentUnit.find(current_period)
        expect(current_unit).to be_nil
      end
    end

    context "#editing after the 19th" do
      it "finds the no crate" do
        Timecop.freeze(2015, 1, 20)
        current_unit = Subscription::CurrentUnit.find(current_period)
        expect(current_unit).to be_nil
      end
    end
  end
end
