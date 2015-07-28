require 'rails_helper'
require 'support/recurly/coupon'

RSpec.configure do |c|
  c.extend Support::Recurly::Coupon
end

describe Promotion do
  subject{ build :promotion }

  it { expect(subject).to be_valid }  # Factory valid?

  describe "Associations" do
    it { should have_and_belong_to_many(:eligible_plans).class_name('Plan') }
    it { should have_many(:coupons) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { expect(build :promotion, coupon_prefix: '').to_not be_valid }
    it { should validate_presence_of(:coupon_prefix) }
    it { should validate_uniqueness_of(:coupon_prefix).case_insensitive }
    it { should validate_length_of(:coupon_prefix).is_at_most(50) }
    it { should allow_value(true, false).for(:one_time_use) }
    it { should_not allow_value(nil).for(:one_time_use) }
    it { should validate_inclusion_of(:adjustment_type).in_array(%w(Percentage Fixed)) }
    it { should validate_presence_of(:adjustment_amount) }

    context 'Promotion is single use' do
      before { subject.one_time_use = true }

      it { should allow_value(:nil).for(:conversion_limit) }

      context 'conversion_limit is not set' do
        before { subject.conversion_limit = nil }

        it { should be_valid }
      end

      context 'conversion_limit is set' do
        before { subject.conversion_limit = -1 }

        it { should validate_numericality_of(:conversion_limit).is_greater_than_or_equal_to(0) }
      end
    end

    context 'Promotion is multi use' do
      before { subject.one_time_use = false }

      it { should allow_value(:nil).for(:conversion_limit) }
      it { should_not validate_numericality_of(:conversion_limit) }
    end

    describe 'coupon_prefix (Recurly::Coupon.code) may only contain the following characters: [a-z 0-9 - _ +]' do
      allowed_characters.each do |allowed|
        it "code #{ allowed } should be valid" do
          expect(build :promotion, coupon_prefix: allowed).to be_valid
        end
      end

      disallowed_characters.each do |disallowed|
        it "code #{ disallowed } should be invalid" do
          expect(build :promotion, coupon_prefix: disallowed).to_not be_valid
        end
      end
    end
  end

  describe 'Defaults' do
    subject { Promotion.new }

    it { expect(subject.one_time_use).to eq(false) }
  end

  describe '#generate_new_coupons(codes)' do
    before { subject.save! }
    let(:codes) do
      "COUPON1\nCOUPON2\nCOUPON3"
    end

    it 'creates coupons for promotion' do
      expect{
        subject.generate_new_coupons(codes)
        subject.reload
      }.to change(subject.coupons, :count).by(3)
    end

    it "creates coupons with downcased codes" do
      subject.generate_new_coupons(codes)
      downcased_codes = codes.split(/\n/).map(&:downcase)
      subject.reload

      expect(subject.coupons.pluck(:code)).to match_array downcased_codes
    end
  end
end
