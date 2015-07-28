require 'spec_helper'

describe SubscriptionSyncer do
  let(:subscription) { create(:subscription) }
  let(:chargify_assessment_date) { Date.tomorrow.next_week.next_month }
  let(:chargify_last_4) { '4242' }
  let(:payment_profile) { double('payment_profile', :masked_card_number => chargify_last_4) }
  let(:chargify_sub) { double('chargify_sub', :next_assessment_at => chargify_assessment_date, :payment_profile => payment_profile) }
  let(:syncer) { SubscriptionSyncer.new(subscription) }
  before { allow(Chargify::Subscription).to receive(:find).and_return(chargify_sub)}
  
  describe '#initialize' do
    it 'initializes the syncer' do
      expect(syncer.subscription).to eq(subscription)
    end
  end

  describe '#sync' do
    it 'syncs subscription with a next assessment date' do
      syncer.sync
      expect(subscription.next_assessment_at.to_date).to eq(chargify_assessment_date)
    end

    it 'syncs subscription with its last four CC number' do
      syncer.sync
      expect(subscription.last_4).to eq(chargify_last_4)
    end

    it 'returns false when there is no chargify subscription' do
      allow(Chargify::Subscription).to receive(:find).and_return(nil)
      expect(syncer.sync).to be false      
    end
  end
end