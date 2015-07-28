require 'spec_helper'

describe Product do

  it { is_expected.to have_many(:plans) }

  describe "#sold_out?" do
    let(:product) { create(:product, :with_plan_3_months, max_inventory_count: 5) }
    it 'returns false' do
      plan = product.plans.first
      create(:subscription, plan: plan)

      expect(product.sold_out?).to eq false
    end

    it 'returns true' do
      plan = product.plans.first
      (product.max_inventory_count+1).times do
        create(:subscription, plan: plan)
      end

      expect(product.sold_out?).to eq true
    end
  end
end
