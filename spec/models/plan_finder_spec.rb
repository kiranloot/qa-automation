require 'spec_helper'

describe PlanFinder do
  let!(:au_plans) { [create(:plan_au), create(:plan_au_3_months)] }
  let!(:ca_plans) { [create(:plan_ca), create(:plan_ca_3_months)] }
  let!(:de_plans) { [create(:plan_de), create(:plan_de_3_months)] }
  let!(:dk_plans) { [create(:plan_dk), create(:plan_dk_3_months)] }
  let!(:gb_plans) { [create(:plan_gb), create(:plan_gb_3_months)] }
  let!(:ie_plans) { [create(:plan_ie), create(:plan_ie_3_months)] }
  let!(:nl_plans) { [create(:plan_nl), create(:plan_nl_3_months)] }
  let!(:no_plans) { [create(:plan_no), create(:plan_no_3_months)] }
  let!(:se_plans) { [create(:plan_se), create(:plan_se_3_months)] }
  let!(:us_plans) { [create(:plan), create(:plan_3_months)] }
  let!(:fi_plans) { [create(:plan_fi), create(:plan_fi_3_months)] }
  let!(:fr_plans) { [create(:plan_fr), create(:plan_fr_3_months)] }
  let!(:nz_plans) { [create(:plan_nz), create(:plan_nz_3_months)] }
  let!(:legacy_plans) { [create(:plan, :legacy_1_month), create(:plan, :legacy_3_month)] }

  describe ".upgradable_plans_for(subscription)" do
    let(:subscription) { create(:subscription) }
    let!(:max_plan) { create(:plan_6_months) }
    let!(:min_plan) { create(:plan) }

    context "when subscription's plan is the max" do
      before do
        subscription.plan = max_plan
      end

      it "does not return any plans" do
        upgradable_plans = PlanFinder.upgradable_plans_for(subscription)

        expect(upgradable_plans).to be_empty
      end
    end

    context "when subscription's plan is min" do
      before do
        subscription.plan = min_plan
      end

      it "returns upgradable_plans" do
        upgradable_plans = PlanFinder.upgradable_plans_for(subscription)

        expect(upgradable_plans).to_not be_empty
      end

      it "returns all plans with greater period" do
        upgradable_plans = PlanFinder.upgradable_plans_for(subscription)
        plans_with_greater_period = upgradable_plans.to_a.keep_if do |plan|
                                      plan.period > min_plan.period
                                    end

        expect(upgradable_plans).to match_array plans_with_greater_period
      end

      it "does not return legacy plans" do
        upgradable_plans = PlanFinder.upgradable_plans_for(subscription)
        expect(upgradable_plans).not_to include(legacy_plans)
      end
    end
  end

  describe ".by_country(country)" do
    context "when country is AU" do
      it "returns all plans for AU" do
        plans = Plan.where(name: au_plans.map(&:name))

        expect(PlanFinder.by_country('AU')).to match_array plans
      end
    end

    context "when country is CA" do
      it "returns all plans for CA" do
        plans = Plan.where(name: ca_plans.map(&:name))

        expect(PlanFinder.by_country('CA')).to match_array plans
      end
    end
    context "when country is DE" do
      it "returns all plans for DE" do
        plans = Plan.where(name: de_plans.map(&:name))

        expect(PlanFinder.by_country('DE')).to match_array plans
      end
    end
    context "when country is DK" do
      it "returns all plans for DK" do
        plans = Plan.where(name: dk_plans.map(&:name))

        expect(PlanFinder.by_country('DK')).to match_array plans
      end
    end
    context "when country is GB" do
      it "returns all plans for GB" do
        plans = Plan.where(name: gb_plans.map(&:name))

        expect(PlanFinder.by_country('GB')).to match_array plans
      end
    end
    context "when country is IE" do
      it "returns all plans for IE" do
        plans = Plan.where(name: ie_plans.map(&:name))

        expect(PlanFinder.by_country('IE')).to match_array plans
      end
    end
    context "when country is NL" do
      it "returns all plans for NL" do
        plans = Plan.where(name: nl_plans.map(&:name))

        expect(PlanFinder.by_country('NL')).to match_array plans
      end
    end

    context "when country is NO" do
      it "returns all plans for NO" do
        plans = Plan.where(name: no_plans.map(&:name))

        expect(PlanFinder.by_country('NO')).to match_array plans
      end
    end

    context "when country is SE" do
      it "returns all plans for SE" do
        plans = Plan.where(name: se_plans.map(&:name))

        expect(PlanFinder.by_country('SE')).to match_array plans
      end
    end

    context "when country is US" do
      it "returns all plans for US" do
        plans = Plan.where(name: us_plans.map(&:name))

        expect(PlanFinder.by_country('US')).to match_array plans
      end

      it "does not return legacy plans" do
        expect(PlanFinder.by_country('US')).not_to include(legacy_plans)

      end
    end

    context "when country is FR" do
      it "returns all plans for FR" do
        plans = Plan.where(name: fr_plans.map(&:name))

        expect(PlanFinder.by_country('FR')).to match_array plans
      end
    end

    context "when country is FI" do
      it "returns all plans for FI" do
        plans = Plan.where(name: fi_plans.map(&:name))

        expect(PlanFinder.by_country('FI')).to match_array plans
      end
    end

    context "when country is NZ" do
      it "returns all plans for NZ" do
        plans = Plan.where(name: nz_plans.map(&:name))

        expect(PlanFinder.by_country('NZ')).to match_array plans
      end
    end

    context "when a country does not exist" do
      it "defaults to US" do
        plans = Plan.where(name: us_plans.map(&:name))

        expect(PlanFinder.by_country('NOCOUNTRY')).to match_array plans
      end
    end
  end
end
