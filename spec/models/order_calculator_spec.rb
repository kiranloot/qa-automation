require 'spec_helper'

RSpec.describe OrderCalculator do
  let(:plan1) { create(:plan) }
  let(:valid_coupon) { create(:coupon) }
  let(:invalid_coupon) { NullCoupon.new }

  describe "#subtotal" do
    context "when there is 1 product" do
      let(:calculator) do
        OrderCalculator.new(
          products: [plan1],
          shipping_address_zip: '91733',
          coupon: valid_coupon
        )
      end

      it "returns the subtotal of a product" do
        subtotal = plan1.cost

        expect(calculator.subtotal).to eq subtotal
      end
    end

    context "when there are multiple products" do
      let(:plan2) { create(:plan_3_months) }
      let(:calculator) do
        OrderCalculator.new(
          products: [plan1, plan2],
          shipping_address_zip: '91733',
          coupon: valid_coupon
        )
      end

      it "returns the subtotal of all products" do
        subtotal = plan1.cost + plan2.cost

        expect(calculator.subtotal).to eq subtotal
      end
    end
  end

  describe "#plan_renewal_cost" do
    context "when ordered from a nontax_state" do
      let(:calculator) do
        OrderCalculator.new(
          products: [plan1],
          shipping_address_zip: '91733',
          coupon: valid_coupon
        )
      end

      it "returns the subtotal of the product(s)" do
        allow(calculator).to receive(:tax_rate) { 0 }
        subtotal = plan1.cost

        expect(calculator.plan_renewal_cost).to eq subtotal
      end
    end

    context "when ordered from a tax_state" do
      let(:calculator) do
        OrderCalculator.new(
          products: [plan1],
          shipping_address_zip: '91733',
          coupon: valid_coupon
        )
      end

      it "returns the subtotal of the product(s) with tax included" do
        allow(calculator).to receive(:tax_rate) { 0.09 }
        subtotal = plan1.cost
        subtotal += subtotal * 0.09

        expect(calculator.plan_renewal_cost).to eq subtotal.round(2)
      end
    end
  end

  describe "#total" do
    context "when ordered from a nontax_state" do
      let(:calculator) do
        OrderCalculator.new(
          products: [plan1],
          shipping_address_zip: '91733',
          coupon: invalid_coupon
        )
      end
      let(:tax_retriever) { instance_double(TaxRetriever) }
      
      before do
        tax_details = { rate: 0 }
        allow(tax_retriever).to receive(:get_tax_details) { tax_details }
        allow(TaxRetriever).to receive(:new) { tax_retriever }
      end

      it "returns the order total cost" do
        total_cost = plan1.cost

        expect(calculator.total).to eq total_cost
      end

      context "with a valid_coupon" do
        it "returns the order discounted total cost" do
          allow(calculator).to receive(:coupon).and_return(valid_coupon)
          total_cost = plan1.cost - valid_coupon.total_discount_amount(plan1.cost)

          expect(calculator.total).to eq total_cost.to_f
        end

        it "returns 0 when discounted amount is greater than order total" do
          total_cost = plan1.cost
          allow(calculator).to receive(:coupon_discount_amount).and_return(total_cost + 10.00)

          expect(calculator.total).to eq 0
        end
      end
    end

    context "when ordered from a tax_state" do
      let(:calculator) do
        OrderCalculator.new(
          products: [plan1],
          shipping_address_zip: '91733',
          coupon: invalid_coupon
        )
      end
      let(:tax_details) { {rate: 0.09} }
      let(:tax_retriever) { instance_double(TaxRetriever) }
      
      before do
        allow(tax_retriever).to receive(:get_tax_details) { tax_details }
        allow(TaxRetriever).to receive(:new) { tax_retriever }
      end

      it "returns the order total cost with tax included" do
        total_cost = plan1.cost + (plan1.cost * tax_details[:rate])

        expect(calculator.total).to eq total_cost.round(2)
      end

      context "with a valid_coupon" do
        it "returns the order discounted total cost with tax included" do
          allow(calculator).to receive(:coupon).and_return(valid_coupon)

          subtotal               = plan1.cost
          coupon_discount_amount = valid_coupon.total_discount_amount(subtotal)
          tax_charge             = (subtotal - coupon_discount_amount) * tax_details[:rate]
          total_cost             = [subtotal - coupon_discount_amount + tax_charge, 0].max

          expect(calculator.total).to eq total_cost.to_f.round(2)
        end
      end
    end
  end

  describe "#next_assessment_at" do
    after { Timecop.return }

    context "when it is between the 6th to the 19th (EST)" do
      let(:current_time) { DateTime.new(2015, 02, 07) }
      before { Timecop.freeze(current_time) }

      context "and it is a 1 month plan" do
        let(:one_month_plan) { create(:plan) }
        let(:calculator) { OrderCalculator.new(products: [one_month_plan]) }

        it "returns the 5th of next month" do
          expected_date = (current_time.in_time_zone('Eastern Time (US & Canada)').change(day: 5)) + 1.month

          expect(calculator.next_assessment_at).to eq expected_date
        end
      end

      context "and it is a 6 months plan" do
        let(:six_month_plan) { create(:plan_6_months) }
        let(:calculator) { OrderCalculator.new(products: [six_month_plan]) }

        it "returns the 5th of the month, 6 months later" do
          expected_date = (current_time.in_time_zone('Eastern Time (US & Canada)').change(day: 5)) + 6.month

          expect(calculator.next_assessment_at).to eq expected_date
        end
      end
    end

    context "when is is NOT between the 6th to the 19th (EST)" do
      let(:current_time) { Time.new(2015, 02, 21) }
      before { Timecop.freeze(current_time) }

      context "and it is a 1 month plan" do
        let(:one_month_plan) { create(:plan) }
        let(:calculator) { OrderCalculator.new(products: [one_month_plan]) }

        it "returns the 21st of the next month" do
          expected_date = (current_time.in_time_zone('Eastern Time (US & Canada)')) + 1.month

          expect(calculator.next_assessment_at).to eq expected_date
        end
      end

      context "and it is a 6 months plan" do
        let(:six_month_plan) { create(:plan_6_months) }
        let(:calculator) { OrderCalculator.new(products: [six_month_plan]) }

        it "returns the 21st of the month, 6 months later" do
          expected_date = (current_time.in_time_zone('Eastern Time (US & Canada)')) + 6.month

          expect(calculator.next_assessment_at).to eq expected_date
        end
      end
    end
  end
end