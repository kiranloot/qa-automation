describe 'admin/subscriptions/_flag_invalid_address' do

  let(:subscription) { build_stubbed(:subscription) }

  before do
    controller.request.path_parameters[:id] = subscription.id
  end

  it 'displays flag button if shipping address is not currently flagged' do
    render partial: 'flag_invalid_address', locals: {subscription: subscription}

    expect(rendered).to match /Flag invalid shipping address/
  end

  it 'displays unflag button if shipping address is current flagged as invalid' do
    allow_any_instance_of(ShippingAddress).to receive(:flagged_invalid_at).and_return DateTime.now

    render partial: 'flag_invalid_address', locals: {subscription: subscription}

    expect(rendered).to match /Remove invalid shipping flag/
  end

end
