require 'spec_helper'
require 'support/recurly/coupon'

RSpec.configure do |c|
  c.extend Support::Recurly::Coupon
end

describe Coupon do
  subject{ build :coupon }

  it 'has a valid factory' do
    expect(build(:coupon)).to be_valid
  end

  describe 'Validations' do
    it { expect(build :coupon, code: '').to_not be_valid }
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
  end

  describe 'defaults' do
    it { expect(subject.status).to eq('Active') }
  end

  describe '#archive!' do
    it "changes status to 'Inactive'" do
      expect{
        subject.archive!
        subject.reload
      }.to change{subject.status}.from('Active').to('Inactive')
    end
  end

  describe 'before_save hook' do
    let(:uppercase) { create(:coupon, code: 'ALL_UPPERCASE_CODE') }
    let(:mixedcase) { create(:coupon, code: 'MixED_Case_CoDe') }
    let(:lowercase) { create(:coupon, code: 'all_lowercase_code') }
    let(:up_converted) { 'all_uppercase_code' }
    let(:mix_converted) { 'mixed_case_code' }
    let(:low_converted) { 'all_lowercase_code' }

    it 'saves code as lowercase' do
      expect(uppercase.code).to eq(up_converted)
      expect(mixedcase.code).to eq(mix_converted)
      expect(lowercase.code).to eq(low_converted)
    end
  end
end
