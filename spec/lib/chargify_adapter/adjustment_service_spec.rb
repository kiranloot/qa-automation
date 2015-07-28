require 'spec_helper'

describe ChargifyAdapter::AdjustmentService do
  describe '#create' do
    let(:subscription) { create(:subscription) }
    let(:chargify_sub) { double("chargify_double") }
    it 'calls chargify adjustment api' do
      allow(ChargifySwapper).to receive(:set_chargify_site_for)
      allow(Chargify::Subscription).to receive(:find).and_return(chargify_sub)
      expect(chargify_sub).to receive(:adjustment)

      ChargifyAdapter::AdjustmentService.new(subscription, -500).create
    end
  end
end
