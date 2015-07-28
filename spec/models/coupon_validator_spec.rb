require 'spec_helper'

describe CouponValidator do
  let(:code) { 'abc123' }
  let(:plan) { create(:plan) }
  let(:coupon_validator) { CouponValidator.new(code, plan, 'SIGNUP') }

  describe "#validate!" do
    before do
      allow(coupon_validator).to receive(:check_promotion_date).and_return(true)
      allow(coupon_validator).to receive(:check_plan_for_eligibility).and_return(true)
      allow(coupon_validator).to receive(:check_usage_limit).and_return(true)
    end

    it "is case insensitive" do
      coupon_validator = CouponValidator.new('ABC123', plan, 'SIGNUP')
      promotion = create(:promotion, eligible_plans: [plan])
      create(:coupon, code: code, promotion: promotion)

      coupon_validator.validate!

      expect(coupon_validator.errors[:invalid_code]).to be_empty
    end

    context "when code does not exists" do
      it "adds an invalid_code error to validator" do
        coupon_validator.validate!

        expect(coupon_validator.errors[:invalid_code]).to_not be_empty
      end
    end

    context "when code is inactive" do
      it "adds an invalid_code error to validator" do
        create(:coupon, code: code, status: 'Inactive')

        coupon_validator.validate!

        expect(coupon_validator.errors[:invalid_code]).to_not be_empty
      end
    end
  end

  describe "#check_trigger_event" do
    before do
      @promotion = create(:promotion, trigger_event: 'REACTIVATION')
      coupon = double('coupon', promotion: @promotion, code: code)

      allow(coupon_validator).to receive(:coupon).and_return(coupon)
      allow(coupon_validator).to receive(:check_plan_for_eligibility).and_return(true)
      allow(coupon_validator).to receive(:check_usage_limit).and_return(true)
      allow(coupon_validator).to receive(:check_promotion_date).and_return(true)
    end

    it "adds ineligible_trigger_event error when trigger_event is ineligible" do
      coupon_validator.validate!

      expect(coupon_validator.errors[:ineligible_trigger_event]).to_not be_empty
    end

    it "does not add an ineligible_trigger_event error when trigger_event is eligible" do
      coupon_validator.validate!
    end
  end

  describe "#check_promotion_date" do
    before do
      @promotion = create(:promotion)
      coupon = double('coupon', promotion: @promotion, code: code)

      allow(coupon_validator).to receive(:coupon).and_return(coupon)
      allow(coupon_validator).to receive(:check_plan_for_eligibility).and_return(true)
      allow(coupon_validator).to receive(:check_usage_limit).and_return(true)
    end
    after { Timecop.return }

    context "when coupon is within valid date" do
      it "does not add errors" do
        Timecop.freeze(@promotion.starts_at)
        coupon_validator.validate!

        expect(coupon_validator.errors[:invalid_date]).to be_empty
      end
    end

    context "when coupon is NOT within valid date" do
      it "adds invalid_date error" do
        Timecop.freeze(@promotion.starts_at - 1.day)
        coupon_validator.validate!

        expect(coupon_validator.errors[:invalid_date]).to_not be_empty
      end
    end
  end

  describe "#check_plan_for_eligibility" do
    context "when plan is eligible" do
      before do
        @promotion = create(:promotion, eligible_plans: [plan])
        coupon = double('coupon', promotion: @promotion, code: code)

        allow(coupon_validator).to receive(:coupon).and_return(coupon)
        allow(coupon_validator).to receive(:check_promotion_date).and_return(true)
        allow(coupon_validator).to receive(:check_usage_limit).and_return(true)
      end

      it "does not add an ineligible_plan error" do
        coupon_validator.validate!

        expect(coupon_validator.errors[:ineligible_plan]).to be_empty
      end
    end

    context "when plan is NOT eligible" do
      before do
        @promotion = create(:promotion)
        @promotion.eligible_plans.delete_all
        coupon = double('coupon', promotion: @promotion, code: code)

        allow(coupon_validator).to receive(:coupon).and_return(coupon)
        allow(coupon_validator).to receive(:check_promotion_date).and_return(true)
        allow(coupon_validator).to receive(:check_usage_limit).and_return(true)
      end

      it "adds an ineligible_plan error" do
        coupon_validator.validate!

        expect(coupon_validator.errors[:ineligible_plan]).to_not be_empty
      end
    end
  end

  describe "#check_usage_limit" do
    before do
      allow(coupon_validator).to receive(:check_promotion_date).and_return(true)
      allow(coupon_validator).to receive(:check_plan_for_eligibility).and_return(true)
    end

    context "when coupon is one time use" do
      context "and it has not been used" do
        it "does not add an already_used error" do
          promotion = create(:promotion, one_time_use: true)
          coupon = double('coupon', promotion: promotion, code: code, usage_count: 0)
          allow(coupon_validator).to receive(:coupon).and_return(coupon)

          coupon_validator.validate!

          expect(coupon_validator.errors[:already_used]).to be_empty
        end
      end

      context "and it has been used" do
        it "adds already_used" do
          promotion = create(:promotion, one_time_use: true)
          coupon = double('coupon', promotion: promotion, code: code, usage_count: 1)
          allow(coupon_validator).to receive(:coupon).and_return(coupon)

          coupon_validator.validate!

          expect(coupon_validator.errors[:already_used]).to_not be_empty
        end
      end
    end

    context "when coupon is NOT one time use" do
      context "and usage_count is less than conversion limit" do
        it "does not add a limit_reached error" do
          promotion = create(:promotion, one_time_use: false, conversion_limit: 100)
          coupon = double('coupon', promotion: promotion, code: code, usage_count: 10)
          allow(coupon_validator).to receive(:coupon).and_return(coupon)

          coupon_validator.validate!

          expect(coupon_validator.errors[:limit_reached]).to be_empty
        end
      end

      context "and usage_count has reached conversion limit" do
        it "adds a limit_reached error" do
          promotion = create(:promotion, one_time_use: false, conversion_limit: 100)
          create(:coupon, promotion: promotion, code: code, usage_count: 90)
          coupon = create(:coupon, promotion: promotion, code: 'random22', usage_count: 10)
          allow(coupon_validator).to receive(:coupon).and_return(coupon)

          coupon_validator.validate!

          expect(coupon_validator.errors[:limit_reached]).to_not be_empty
        end
      end
    end
  end
end
