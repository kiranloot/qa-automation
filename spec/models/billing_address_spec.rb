require 'spec_helper'

describe BillingAddress do
#  let(:subject) { FactoryGirl.build(:billing_address) }

  # validation rules
  it { is_expected.to validate_presence_of(:full_name) }

  it 'validates full name format as at least 2 words' do
    address = FactoryGirl.build(:billing_address, :full_name => "Bob")
    expect(address).not_to be_valid
  end

  it 'reads and writes a credit card instance' do
    address = FactoryGirl.build(:billing_address,
                                :credit_card => {
                                  :number => '1',
                                  :cvv => '111',
                                  'expiration(1i)' => '2023',
                                  'expiration(2i)' => '1',
                                  'expiration(3i)' => '1'
                                })
    allow(CreditCard).to receive(:new) { FactoryGirl.build(:credit_card) }
    expect(address.credit_card).to be_a CreditCard
  end

  it 'returns line_1 on #to_s' do
    address = FactoryGirl.build(:billing_address, line_1: "666 Stix Rvr")
    expect(address.to_s).to eq("666 Stix Rvr")
  end

  # Class Methods
  it 'syncs billing address from chargify hash' do
    address = FactoryGirl.create(:billing_address)
    chargify_hash = {
      first_name:         address.first_name,
      last_name:          address.last_name,
      billing_address:    address.line_1,
      billing_address_2:  address.line_2,
      billing_city:       address.city,
      billing_state:      address.state,
      billing_zip:        address.zip,
      billing_country:    address.country
    }
    ba_hash = BillingAddress.sync_or_create_billing_address_from_chargify(chargify_hash)
    expect(ba_hash.keys).to eq([:billing_address_id])
  end

  it 'creates billing address from chargify hash' do
    chargify_hash = {
      first_name:        "El",
      last_name:         "Diablo",
      billing_address:   "666 Stix Rvr",
      billing_city:      "Hell",
      billing_state:     "CA",
      billing_zip:       "90025",
      billing_country:   "US"
    }
    ba_hash = BillingAddress.sync_or_create_billing_address_from_chargify(chargify_hash)
    expect(ba_hash.keys).to eq([:billing_address_attributes])
  end
end
