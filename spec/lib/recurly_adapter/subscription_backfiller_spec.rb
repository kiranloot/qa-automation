require 'spec_helper'

describe RecurlyAdapter::SubscriptionBackfiller do

  describe 'backfill' do
    let!(:subscription_backfiller_job) do
      create(:subscription_backfiller_job, next_assessment_at: DateTime.new(2015, 7, 1))
    end
    let!(:backfiller) { RecurlyAdapter::SubscriptionBackfiller.new }
    let!(:account) { double('account') }

    it 'creates a subscription for the account' do
      expect(Recurly::Subscription).to receive(:create).with(
        account: { account_code: subscription_backfiller_job.account_code },
        plan_code: subscription_backfiller_job.plan_code,
        currency: 'USD',
        starts_at: subscription_backfiller_job.starts_at,
        trial_ends_at: subscription_backfiller_job.next_assessment_at
      )
      backfiller.backfill
    end

    before { Timecop.freeze }
    it 'adjust the next assessment date to the 29th' do
      subscription_backfiller_job.update_attributes(next_assessment_at: DateTime.new(2015, 06, 26))
      expect(Recurly::Subscription).to receive(:create).with(
        account: { account_code: subscription_backfiller_job.account_code },
        plan_code: subscription_backfiller_job.plan_code,
        currency: 'USD',
        starts_at: subscription_backfiller_job.starts_at,
        trial_ends_at: DateTime.new(2015, 06, 29).at_middle_of_day
      )
      backfiller.backfill
    end
    after { Timecop.return }


    describe 'updates' do
      let(:sub) { create(:subscription) }
      let(:account) { double('account', account_code: '123') }
      let(:recurly_sub) { double('recurly_sub', account: account, uuid: '321') }

      before do
        subscription_backfiller_job.update_attributes(subscription_id: sub.id)
        allow(Recurly::Subscription).to receive(:create) { recurly_sub }
      end

      it 'updates the job status once it succeeds' do
        backfiller.backfill

        subscription_backfiller_job.reload
        expect(subscription_backfiller_job.status).to eq('success')
      end

      it 'updates the subscription with the correct recurly_sub id' do
        backfiller.backfill

        sub.reload
        expect(sub.recurly_subscription_id).to eq('321')
      end

      it 'updates the subscription with the correct account id' do
        backfiller.backfill

        sub.reload
        expect(sub.recurly_account_id).to eq('123')
      end
    end

    context 'edge cases' do
      describe 'job already succeeded' do
        it 'should not do anything' do
          subscription_backfiller_job.update_attribute(:status, 'success')
          expect(Recurly::Subscription).to_not receive(:create)
          backfiller.backfill
        end
      end
    end
  end

  describe 'csv_import' do
    it 'opens csv and imports rows into db' do
      filename = './spec/support/recurly_migration_test_files/subscription-backfill-small.csv'
      expect{RecurlyAdapter::SubscriptionBackfiller.csv_import(filename)}.
        to change{SubscriptionBackfillerJob.count}.by(10)
    end

    it 'throws error if no file can be found' do
      filename = './no_such_file.txt'
      expect{RecurlyAdapter::SubscriptionBackfiller.csv_import(filename)}.to raise_error(
        Errno::ENOENT
      )
    end

  end
end
