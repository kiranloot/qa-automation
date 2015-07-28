require 'spec_helper'

describe Address do
  # validation rules
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:line_1) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:state) }
  it { is_expected.to validate_presence_of(:zip) }
  it { is_expected.to validate_presence_of(:country) }

  it 'should validate existence of Country' do
    address = FactoryGirl.build(:address, :country => "ZZ")
    expect(address).not_to be_valid
  end

  it 'should validate existence of State' do
    address = FactoryGirl.build(:address, :state => "ZZ")
    expect(address).not_to be_valid
  end

  it 'should validate format of Country' do
    address = FactoryGirl.build(:address, :country => "United States")
    expect(address).not_to be_valid
  end

  it 'should validate format of State' do
    address = FactoryGirl.build(:address, :state => "California")
    expect(address).not_to be_valid
  end

  it 'uses AA as valid state in the United States' do
    address = FactoryGirl.build(:address, :state => "AA")
    expect(address.readable_state).to eq("Armed Forces Americas")
    expect(address.valid_state?).to be_truthy
  end

  it 'uses AE as valid state in the United States' do
    address = FactoryGirl.build(:address, :state => "AE")
    expect(address.readable_state).to eq("Armed Forces Europe")
    expect(address.valid_state?).to be_truthy
  end

  it 'uses AP as valid state in the United States' do
    address = FactoryGirl.build(:address, :state => "AP")
    expect(address.readable_state).to eq("Armed Forces Pacific")
    expect(address.valid_state?).to be_truthy
  end

  it 'prints line 1 in #to_s' do
    address = FactoryGirl.build(:address, :state => "AP")
    expect(address.to_s).to eq("123 Street")
  end

  # class methods
  it 'returns Canadian regions for billing' do
    options = Address.state_options_for("CA")
    expect(options.last).to eq(["Yukon", "YT"])
  end
end
