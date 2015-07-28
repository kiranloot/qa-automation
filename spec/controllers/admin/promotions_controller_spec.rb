require 'spec_helper'

describe Admin::PromotionsController do
  include_context 'login_admin'
  include_context 'force_ssl'

  describe "GET #new" do
    before do
      get :new
    end

    it "assigns @promotion" do
      expect(assigns(:promotion)).to be_a_new Promotion
    end

    it { should render_template(:new) }
    it { should render_template(layout: 'active_admin') }
  end

  describe 'PUT #update' do
    let(:plan_3_months) { create :plan_3_months }
    let(:plan_6_months) { create :plan_6_months }
    let(:promotion) { create :promotion }
    let(:new_name) { promotion.name + '_changed' }
    let(:new_description) { Faker::Lorem.sentence }
    let(:new_prefix) { promotion.coupon_prefix + '_changed' }
    let(:new_starts_at) { Faker::Date.between(2.years.ago, 1.year.ago).to_s }
    let(:new_ends_at) { Faker::Date.between(1.year.ago, Date.today).to_s }
    let(:new_adjustment_amount) { Faker::Number.positive.to_s }
    let(:new_adjustment_type) { promotion.adjustment_type == 'Fixed' ? 'Percentage' : 'Fixed' }
    let(:new_conversion_limit) { Faker::Number.number(4).to_s }
    let(:new_trigger_event) { 'REACTIVATION' }
    let(:one_time_use) { false }
    let(:update_parameters) { { id: promotion.id,
                                coupon_code: promotion.coupon_prefix,
                                promotion: {
                                  name:              new_name,
                                  description:       new_description,
                                  coupon_prefix:     new_prefix,
                                  trigger_event:     [new_trigger_event],
                                  starts_at:         new_starts_at,
                                  ends_at:           new_ends_at,
                                  adjustment_amount: new_adjustment_amount,
                                  adjustment_type:   new_adjustment_type,
                                  conversion_limit:  new_conversion_limit,
                                  one_time_use:      one_time_use,
                                  eligible_plan_ids: ['', plan_3_months.id.to_s, plan_6_months.id.to_s]
                                }
    } }
    subject{ put :update, update_parameters }

    it 'does not persist changes to name' do
      expect { subject }.not_to change { promotion.reload.name }
    end

    it 'persists changes to ends_at' do
      expect { subject }.to change { promotion.reload.ends_at }.to(new_ends_at.to_date)
    end

    it 'does not persist changes to the coupon_prefix field' do
      expect { subject }.not_to change { promotion.reload.coupon_prefix }
    end

    it 'persists changes to starts_at' do
      expect { subject }.to change { promotion.reload.starts_at }.to(new_starts_at.to_date)
    end

    it 'does not persist changes to one_time_use' do
      expect { subject }.not_to change { promotion.reload.one_time_use }
    end

    it 'does not persist changes to adjustment_amount' do
      expect { subject }.not_to change { promotion.reload.adjustment_amount }
    end

    it 'does not persist changes to adjustment_type' do
      expect { subject }.not_to change { promotion.reload.adjustment_type }
    end

    it 'persists changes to conversion_limit' do
      expect { subject }.to change { promotion.reload.conversion_limit }.to(new_conversion_limit.to_i)
    end

    it 'persists changes to description' do
      expect { subject }.to change { promotion.reload.description }.to(new_description)
    end

    it 'persists changes to trigger events' do
      expect { subject }.to change { promotion.reload.trigger_event }.to(new_trigger_event)
    end

    it 'does not call Recurly::Coupon' do
      expect(Recurly::Coupon).not_to receive(:new)
      subject
    end

    context 'promotion does not have an end date' do
      let(:new_ends_at) { ''}

      it 'sets an ends_at date' do
        expect { subject }.to change { promotion.reload.ends_at }.to('2200-01-01'.to_date)
      end
    end

    describe 'persisting changes to plans' do
      let(:plan) { create :plan }
      before do
        promotion.eligible_plans = [plan, plan_3_months]
        promotion.save!
      end

      it 'deletes existing, non-selected plans & persists selected plans' do
        subject
        expect(promotion.reload.eligible_plans).to contain_exactly(plan_3_months, plan_6_months)
      end
    end

    context 'single use coupons' do
      let(:coupons_requested_params) { { recipients: recipients.join(', '), char_length: code_length, quantity: coupon_quantity } }
      let(:recipients) { [Faker::Internet.email] }
      let(:coupon_quantity) { Faker::Number.positive 1, 1000 }
      let(:code_length) { Faker::Number.positive 3, 15 }
      before do
        promotion.update_attributes one_time_use: true
        update_parameters.delete(:coupon_code)
        update_parameters.merge! coupons_requested_params
      end

      context 'coupons requested' do
        it 'calls PromoCodeWorker' do
          expect(PromoCodeWorker).to receive(:perform_async).with(promotion.id, recipients + [controller.current_admin_user.email], promotion.coupon_prefix, code_length.to_i, coupon_quantity.to_i)
          subject
        end
      end

      context 'coupon quantity 0' do
        let(:coupon_quantity) { '0' }

        it 'does not call PromoCodeWorker' do
          expect(PromoCodeWorker).not_to receive(:perform_async)
          subject
        end
      end

      context 'coupon code length 0' do
        let(:code_length) { '0' }

        it 'does not call PromoCodeWorker' do
          expect(PromoCodeWorker).not_to receive(:perform_async)
          subject
        end
      end
    end
  end

  describe "POST #create" do
    let(:plan) { create(:plan) }
    let(:coupon_prefix) { 'coupon1' }
    let (:promotion_attributes) {
      attributes_for(:promotion).merge(adjustment_amount: 10.00,
                                       conversion_limit: 1234,
                                       trigger_event: ['SIGNUP'],
                                       eligible_plan_ids: [plan.id],
                                       coupon_prefix: 'coupon1'
                                      )
    }

    before do
      coupon_creator = instance_spy(RecurlyAdapter::CouponCreator)
      allow(coupon_creator).to receive_message_chain(:errors, :any?) { false }
      allow(RecurlyAdapter::CouponCreator).to receive(:new) { coupon_creator }
    end

    context "when it is a multiuse promotion" do
      before { promotion_attributes.merge!(one_time_use: false) }

      it "creates a new promotion" do
        expect{
          post :create, { promotion: promotion_attributes, coupon_code: coupon_prefix }
        }.to change(Promotion, :count).by(1)
      end

      it 'persists the coupon_prefix field' do
        post :create, { promotion: promotion_attributes, coupon_code: coupon_prefix }
        expect(Promotion.last.coupon_prefix).to eq promotion_attributes[:coupon_prefix]
      end

      it 'persists starts_at' do
        post :create, { promotion: promotion_attributes, coupon_code: coupon_prefix }
        expect(Promotion.last.starts_at).to eq promotion_attributes[:starts_at]
      end

      it 'persists ends_at' do
        post :create, { promotion: promotion_attributes, coupon_code: coupon_prefix }
        expect(Promotion.last.ends_at).to eq promotion_attributes[:ends_at]
      end

      it 'persists adjustment_amount' do
        post :create, { promotion: promotion_attributes, coupon_code: coupon_prefix }
        expect(Promotion.last.adjustment_amount).to eq promotion_attributes[:adjustment_amount]
      end

      it 'persists adjustment_type' do
        post :create, { promotion: promotion_attributes, coupon_code: coupon_prefix }
        expect(Promotion.last.adjustment_type).to eq promotion_attributes[:adjustment_type]
      end

      it 'persists conversion_limit' do
        post :create, { promotion: promotion_attributes, coupon_code: coupon_prefix }
        expect(Promotion.last.conversion_limit).to eq promotion_attributes[:conversion_limit]
      end

      context "when promotion does not have an end date" do
        before { promotion_attributes[:ends_at] = '' }

        it "sets an ends_at date" do
          post :create, { promotion: promotion_attributes, coupon_code: coupon_prefix }
          expect(Promotion.last.ends_at).to eq '2200-01-01'.to_date
        end
      end

      it "creates a coupon for the promotion" do
        post :create, { promotion: promotion_attributes, coupon_code: coupon_prefix }
        promotion = Promotion.last

        expect(promotion.coupons.size).to eq 1
      end
    end

    context "when it is a single_use promotion" do
      let(:params) do
        {
          promotion: promotion_attributes,
          char_length: '20',
          quantity: '50',
          recipients: 'a@lootcrate.com,b@lootcrate.com'
        }
      end
      before do
        promotion_attributes.merge!(one_time_use: true)
      end

      it "creates coupons for promotion" do
        expect{ post :create, params }.to change{ PromoCodeWorker.jobs.size }.by(1)
      end
    end
  end

  describe '#check_code_availability' do
    it 'returns an error message when coupon_prefix is take' do
      create(:promotion, coupon_prefix: 'loot')

      post :check_code_availability, { coupon_prefix: 'LOOT' }

      expect(response.body).to eq({ error: "Coupon prefix 'loot' is taken." }.to_json)
    end
  end
end
