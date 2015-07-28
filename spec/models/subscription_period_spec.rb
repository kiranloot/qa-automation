require 'rails_helper'

RSpec.describe SubscriptionPeriod, type: :model do
  describe "Associations" do
    it { is_expected.to have_many(:subscription_units) }
  end

  describe "Callbacks" do
    it "ensures no period is active for current subscription before create" do
      period = build(:active_subscription_period)

      expect(period).to receive(:does_not_have_active_period?)

      period.save!
    end
  end

  describe "#units_remaining" do
    it "returns number of subscription_units remaining within period" do
      period = create(:active_subscription_period,
       term_length: 3,
       subscription: create(:subscription)
      )
      create(:subscription_unit, status: 'shipped', subscription_period_id: period.id, month_year: 'APR2015')
      create(:subscription_unit, status: 'awaiting_shipment', subscription_period_id: period.id, month_year: 'MAR2015')

      expect(period.units_remaining).to eq 1
    end

    it "does not return a number less than 0" do
      period = create(:active_subscription_period,
       term_length: 1,
       subscription: create(:subscription)
      )
      create(:subscription_unit, status: 'shipped', subscription_period_id: period.id, month_year: 'APR2015')
      create(:subscription_unit, status: 'awaiting_shipment', subscription_period_id: period.id, month_year: 'MAR2015')
      
      expect(period.units_remaining).to eq 0
    end
  end

  describe "#current_unit" do
    it "returns the current unit for current_crate_month_year" do
      allow(Subscription::CrateDateCalculator).to receive(:current_crate_month_year).and_return('APR2015')
      period = create(:active_subscription_period,
        subscription: create(:subscription)
      )
      unit = create(:subscription_unit,
        month_year: 'APR2015',
        subscription_period: period
      )
      
      expect(period.current_unit).to eq unit
    end
  end
end