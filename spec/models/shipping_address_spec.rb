require 'rails_helper'

describe ShippingAddress, type: :model do
  let(:shipping_country_codes) { %w(US CA GB AU DK DE IE NL NO SE) }

  describe "Validations" do
    it { is_expected.to validate_inclusion_of(:country).in_array(shipping_country_codes) }
  end

  describe "#sync_to_chargify(customer, live=false)" do
    let(:customer) { build(:customer) }
    
  end
end
