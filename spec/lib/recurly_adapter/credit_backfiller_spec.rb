require 'spec_helper'

describe RecurlyAdapter::CreditBackfiller do
  let!(:backfiller) { RecurlyAdapter::CreditBackfiller.new }
  let!(:subscription_backfiller_job) { create(:subscription_backfiller_job, balance: 5.00, status: 'success') }

  describe 'backfill' do

    it 'populates queue to be processed' do
      expect(backfiller).to receive(:populate_job_queue)
      allow(Recurly::Adjustment).to receive(:create) { true }
      backfiller.backfill
    end

    it 'creates an adjustment to accounts' do
      account = double('recurly_account')
      adjustments = double('adjustments')
      allow(Recurly::Account).to receive(:find) { account }
      allow(account).to receive(:adjustments) { adjustments }
      expect(adjustments).to receive(:create!).with(
        description:          'migrated from Chargify Subscription balance',
        unit_amount_in_cents: 500,
        currency:             'USD',
        quantity:             1,
        accounting_code:      'migration_chargify'
      )
      backfiller.backfill
    end

    it 'updates status to successful_credit on successful adjustment' do
      account = double('recurly_account')
      adjustments = double('adjustments', create!: true)
      allow(Recurly::Account).to receive(:find) { account }
      allow(account).to receive(:adjustments) { adjustments }

      backfiller.backfill
      subscription_backfiller_job.reload
      expect(subscription_backfiller_job.status).to eq('successful_credit')
    end

    it 'updates status to failed_credit on failed adjustment' do
      account = double('recurly_account')
      adjustments = double('adjustments')
      allow(Recurly::Account).to receive(:find) { account }
      allow(account).to receive(:adjustments) { adjustments }
      allow(adjustments).to receive(:create!).and_raise

      backfiller.backfill
      subscription_backfiller_job.reload
      expect(subscription_backfiller_job.status).to eq('failed_credit')
    end

    describe 'accounts with no balance' do
      it 'will not receive adjustments' do
        job = create(:subscription_backfiller_job, balance: 0)
        expect(Recurly::Adjustment).to_not receive(:find).with(job.account_code)
        backfiller.backfill
      end
    end
  end

  describe 'populate_job_queue' do
    it 'grabs all jobs that need to be backfilled' do
      backfiller.populate_job_queue
      expect(backfiller.job_queue.size).to eq(1)
    end

    it 'does not grab jobs that has been fulfilled' do
      fulfilled_job = create(:subscription_backfiller_job, status: 'successful_credit', balance: 10.0)
      backfiller.populate_job_queue
      jobs = backfiller.job_queue.pop(true)
      expect(jobs.count).to eq(1)
      expect(jobs.last).to_not eq(fulfilled_job)
    end

    it 'does not grab jobs that has not be successful created on Recurly' do
      not_fulfilled = create(:subscription_backfiller_job, status: nil, balance: 10.0)
      backfiller.populate_job_queue
      jobs = backfiller.job_queue.pop(true)
      expect(jobs.count).to eq(1)
      expect(jobs.last).to_not eq(not_fulfilled)
    end

  end

end
