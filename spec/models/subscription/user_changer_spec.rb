require 'rails_helper'

RSpec.describe Subscription::UserChanger, type: :model do
  let(:new_user) { create :batman }
  let(:original_user) { create :user }
  let(:subscription) { create :subscription, user: original_user }
  subject { Subscription::UserChanger.new subscription, new_user }

  it 'should initialize subscription' do
    expect(subject.subscription).to eq(subscription)
  end

  it 'should intialize new user' do
    expect(subject.new_user).to eq(new_user)
  end

  describe '#perform' do
    let(:recurly_account_service) { instance_spy RecurlyAdapter::AccountService }
    before do
      expect(RecurlyAdapter::AccountService).to receive(:new).with(subscription.recurly_account_id) { recurly_account_service }
      expect(recurly_account_service).to receive(:update).with(email: new_user.email)
    end

    describe 'remove subscription from original user' do
      it 'subscription is not found in original user subscriptions' do
        subject.perform
        expect(original_user.subscriptions).not_to include(subscription)
      end

      it { expect{ subject.perform }.to change{ original_user.subscriptions.count }.by(-1) }
    end

    describe 'add subscription to new user' do
      it 'subscription is found in new user subscriptions' do
        subject.perform
        expect(new_user.subscriptions).to include(subscription)
      end

      it { expect{ subject.perform }.to change{ new_user.subscriptions.count }.by(1) }
    end
  end
end
