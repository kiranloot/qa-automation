require 'spec_helper'
include Devise::TestHelpers

describe "subscriptions/upgrade_preview.html.erb" do
  let(:user) { create(:user) }
  let(:subscription) { create(:subscription) }
  let(:upgradable_plans) do
    [create(:plan_6_months), create(:plan_3_months)]
  end
  let(:upgrade_preview) do
    {
      prorated_amount_in_cents: -110,
                   charge_in_cents: 10599,
              payment_due_in_cents: 10489,
           credit_applied_in_cents: 0
    }
  end

  before do
    sign_in user
    credit_card  = double('credit_card', masked_card_number: '1234')
    chargify_sub = double('chargify_sub', credit_card: credit_card)
    assign(:upgradable_plans, upgradable_plans)
    assign(:upgrade_preview, upgrade_preview)
    assign(:plan, upgradable_plans.first)
    assign(:subscription, subscription)
    assign(:current_payment_info, chargify_sub)
  end

  context "when there are upgradable_plans" do
    it "displays upgrade form" do
      render

      expect(rendered).to match("YOUR UPGRADE DETAILS")
    end
  end

  context "when there are no upgradable_plans" do
    before do
      assign(:upgradable_plans, [])
      render
    end

    it "displays a back to subscription" do
      expect(rendered).to match('Go back to subscription')
      expect(rendered).to match('You already have the best plan!')
    end

    it "does not display the upgrade form" do
      plan_name = upgradable_plans.last.name

      expect(rendered).to_not match("#{plan_name}")
    end
  end
end
