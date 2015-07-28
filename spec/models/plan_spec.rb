require 'spec_helper'

describe Plan do
  let(:plan)        { FactoryGirl.build(:plan, savings_copy: "Cancel Anytime") }
  let(:ca_plan)     { FactoryGirl.build(:plan_ca) }
  let(:au_plan)     { FactoryGirl.build(:plan_au, name: "au-1-month-subscription") }
  let(:gb_plan)     { FactoryGirl.build(:plan_gb, name: "gb-1-month-subscription") }

  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:cost) }
  it { is_expected.to validate_presence_of(:period) }
  it { is_expected.to validate_presence_of(:shipping_and_handling) }
  it { is_expected.to belong_to(:product) }

  describe "#is_upgradable?" do
    let(:top_plan) { build(:plan) }

    context "when current plan is the highest" do
      before do
        plan.period = Plan::TOP_PLAN_PERIOD
      end

      it "returns false" do
        expect(plan.is_upgradable?).to eq false
      end
    end

    context "when current plan is not the highest" do
      before do
        plan.period = Plan::TOP_PLAN_PERIOD - 1
      end

      it "returns true" do
        expect(plan.is_upgradable?).to eq true
      end
    end
  end

  describe "#is_legacy?" do
    it 'returns true' do
      legacy_plan = create(:plan, :legacy_1_month)
      expect(legacy_plan.is_legacy?).to eq(true)
    end

    it 'returns false' do
      expect(plan.is_legacy?).to eq(false)
    end

    context 'extra spaces in name' do
      it 'returns true' do
        legacy_plan = create(:plan, :legacy_1_month, name: ' 1-month-subscription-v1 ')
        expect(legacy_plan.is_legacy?).to eq(true)
      end

      it 'returns false' do
        legacy_plan = create(:plan, name: ' 1-month-subscription ')
        expect(legacy_plan.is_legacy?).to eq(false)
      end
    end
  end

  # custom presenter methods
  it '#readable_name' do
    expect(plan.readable_name).to    eq("1 month subscription")
    expect(ca_plan.readable_name).to eq("ca 1 month subscription")
  end

  it '#readable_title' do
    expect(plan.readable_title).to    eq("1 month plan")
    expect(ca_plan.readable_title).to eq("1 month plan")
  end

  it '#monthly_cost' do
    expect(plan.monthly_cost).to    eq(13.37)
    expect(ca_plan.monthly_cost).to eq(29.95)
  end

  it '#css_link_id' do
    expect(plan.css_link_id).to    eq("one-month")
    expect(ca_plan.css_link_id).to eq("one-month")
  end

  it '#country' do
    expect(plan.country).to    eq("US")
    expect(ca_plan.country).to eq("CA")
    expect(au_plan.country).to eq("AU")
    expect(gb_plan.country).to eq("GB")
  end

end
