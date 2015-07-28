require 'rails_helper'

RSpec.describe CreatePromotionWithRecurlyCoupon do
  let(:promotion) { Promotion.new(attributes_for :promotion) }
  let(:eligible_plans) { [build(:plan), build(:plan_3_months), build(:plan_6_months), build(:plan_12_months)] }
  subject{ CreatePromotionWithRecurlyCoupon.new promotion, eligible_plans }

  describe '#initialize' do
    it { expect(subject.promotion).to eq(promotion) }
    it { expect(subject.eligible_plans).to match(eligible_plans) }
    it { expect(subject.errors).to be_a(ActiveModel::Errors) }
    it { expect(subject.errors).to be_empty }
  end

  describe '#perform' do
    context 'valid promotion' do
      let(:coupon_creator) { instance_spy(RecurlyAdapter::CouponCreator) }
      before do
        allow(RecurlyAdapter::CouponCreator).to receive(:new) { coupon_creator }
        allow(coupon_creator).to receive_message_chain(:errors, :any?) { false }
      end

      describe 'is persisted' do
        it { expect { subject.perform }.to change{ Promotion.count }.by(1) }
        it {
          subject.perform
          expect(Promotion.last.coupon_prefix).to eq(promotion.coupon_prefix)
        }
      end

      it 'is created in Recurly' do
        subject.perform

        expect(coupon_creator).to have_received(:fulfill) { true }
      end

      context 'and valid eligible plans' do
        describe 'are persisted' do
          it {
            subject.perform
            expect(Promotion.last.eligible_plans.pluck(:name)).to match(eligible_plans.map(&:name))
          }
        end
      end
    end

    context 'invalid promotion' do
      before { promotion.coupon_prefix = nil }

      it { expect{ subject.perform }.to change{ Promotion.count }.by(0) }
      it { expect{ subject.perform }.to change{ subject.errors.size }.by(1) }
    end

    context 'failed to create external coupon' do
      let(:coupon_creator) { instance_spy(RecurlyAdapter::CouponCreator) }
      before do
        errors = ActiveModel::Errors.new coupon_creator
        errors.add :api_failed, 'Timed out'
        allow(RecurlyAdapter::CouponCreator).to receive(:new) { coupon_creator }
        allow(coupon_creator).to receive_message_chain(:errors, :any?) { true }
        allow(coupon_creator).to receive(:errors) { errors }
      end

      subject { CreatePromotionWithRecurlyCoupon.new promotion, eligible_plans }

      it { expect{ subject.perform }.to change{ Promotion.count }.by(0) }
      it { expect{ subject.perform }.to change{ subject.errors.size }.by(1) }
    end
  end
end
