require 'spec_helper'

describe RecurlyAdapter::SubscriptionUpgradeCalculator do
  let(:upgrade_data) { double('upgrade_data') }
  let(:account) { double('account') }
  let(:recurly_sub) { double('sub') }
  let(:calculator) { RecurlyAdapter::SubscriptionUpgradeCalculator.new(upgrade_data, account, recurly_sub) }
  
  describe "#upgrade_charge_amount_in_cents" do
    it "returns upgrade amount based on desired_plan cost and prorated amount" do
      allow(calculator).to receive(:adjusted_plan_cost_in_cents) { 2000 }
      allow(calculator).to receive(:prorated_amount_in_cents).and_return(1000)
      expected_amount = calculator.adjusted_plan_cost_in_cents - calculator.prorated_amount_in_cents
      
      expect(calculator.upgrade_charge_amount_in_cents).to eq(expected_amount)
    end
  end

  describe "#prorated_amount_in_cents" do
    it "returns prorated amount based on cost of current period, units remaining, and term length" do
      allow(calculator).to receive(:cost_of_current_period_in_cents).and_return(1000)
      allow(upgrade_data).to receive(:current_period_term_length) { 3 }
      allow(upgrade_data).to receive(:units_remaining) { 1 }

      prorated_amount_in_cents = (calculator.cost_of_current_period_in_cents / 3) * 1

      expect(calculator.prorated_amount_in_cents).to eq prorated_amount_in_cents
    end
  end

  describe "#cost_of_current_period_in_cents" do
    it "returns total cost" do
      transaction = double('transaction',
        amount_in_cents: 1000,
        action: 'purchase',
      )
      allow(calculator).to receive(:current_successful_transactions).and_return([transaction])
      
      expect(calculator.cost_of_current_period_in_cents).to eq transaction.amount_in_cents
    end

    it "adjust cost for refunded transactions" do
      purchase_transaction = double('purchase_transaction',
        amount_in_cents: 1000,
        action: 'purchase',
      )
      refund_transaction = double('refund_transaction',
        amount_in_cents: 500,
        action: 'refund',
      )
      allow(calculator).to receive(:current_successful_transactions).and_return([purchase_transaction, refund_transaction])
      total_cost_in_cents = purchase_transaction.amount_in_cents - refund_transaction.amount_in_cents

      expect(calculator.cost_of_current_period_in_cents).to eq(total_cost_in_cents)
    end
  end

  describe "#current_successful_transactions" do
    it "returns only transactions within current_period" do
      period_started_at   = 1.month.ago
      current_transaction = double('current_transaction',
        created_at: DateTime.now,
        status: 'success'
      )
      old_transaction     = double('old_transaction',
        created_at: period_started_at - 1.month,
        status: 'success'
      )
      allow(account).to receive(:transactions).and_return([current_transaction, old_transaction])
      allow(calculator).to receive(:current_period_started_at).and_return(period_started_at)

      expect(calculator.current_successful_transactions).to contain_exactly(current_transaction)
    end

    it 'returns transactions within 1 hour prior to current_period_started_at' do
      period_started_at   = DateTime.now
      current_transaction = double('current_transaction',
        created_at: period_started_at,
        status: 'success'
      )
      old_transaction     = double('old_transaction',
        created_at: period_started_at - 1.month,
        status: 'success'
      )
      allow(account).to receive(:transactions).and_return([current_transaction, old_transaction])
      allow(calculator).to receive(:current_period_started_at).and_return(period_started_at)

      expect(calculator.current_successful_transactions).to contain_exactly(current_transaction)

    end

    it "returns only successful transactions" do
      period_started_at      = 1.month.ago
      successful_transaction = double('successful_transaction',
        created_at: DateTime.now,
        status: 'success'
      )
      declined_transaction   = double('declined_transaction',
        created_at: DateTime.now,
        status: 'declined'
      )
      allow(account).to receive(:transactions).and_return([successful_transaction, declined_transaction])
      allow(recurly_sub).to receive(:current_period_started_at) { period_started_at }

      expect(calculator.current_successful_transactions).to contain_exactly(successful_transaction)
    end
  end
end