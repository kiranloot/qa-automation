require 'rails_helper'

RSpec.describe User::EmailChanger, type: :model do
  let(:user) { create :user }
  let(:subscription) { create :subscription, user: user }
  let(:new_email) { Faker::Internet.email }
  subject { User::EmailChanger.new user, new_email }

  describe '#perform' do
    it 'updates user with new email' do
      old_email = user.email
      expect{ subject.perform }.to change{ user.reload.email }.from(old_email).to(new_email)
    end

    it 'sends new email to Recurly for each subscription' do
      recurly_account_service = instance_spy(RecurlyAdapter::AccountService)
      expect(RecurlyAdapter::AccountService).to receive(:new).ordered.with(subscription.recurly_account_id) { recurly_account_service }
      expect(recurly_account_service).to receive(:update).ordered.with(email: new_email)

      subject.perform
    end
  end
end
