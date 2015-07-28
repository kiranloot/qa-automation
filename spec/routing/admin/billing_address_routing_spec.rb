require 'rails_helper'

RSpec.describe 'Admin::BillingAddressController', type: :routing do
  let(:billing_address_base) { '/admin/billing_addresses' }

  it 'does not route to #create' do
    expect(post: billing_address_base).not_to be_routable
  end

  it 'does not route to #edit' do
    expect(get: "#{ billing_address_base }/1/edit").not_to be_routable
  end

  it 'routes to #update' do
    expect(put: "#{ billing_address_base }/1").not_to be_routable
  end

  it 'does not route to #destroy' do
    expect(delete: "#{ billing_address_base }/1").not_to be_routable
  end
end
