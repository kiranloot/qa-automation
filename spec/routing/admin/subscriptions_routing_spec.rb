require "rails_helper"

RSpec.describe Admin::SubscriptionsController, type: :routing do
  it 'does not route to #create' do
    expect(post: '/admin/subscriptions').not_to be_routable
  end

  it 'does not route to #new' do
    expect(get: '/admin/subscriptions/new').not_to be_routable
  end

  it 'does not route to #destroy' do
    expect(delete: '/admin/subscriptions/1').not_to be_routable
  end

  it 'routes to #update' do
    expect(put: '/admin/subscriptions/1').to route_to('admin/subscriptions#update', id: '1')
  end
end
