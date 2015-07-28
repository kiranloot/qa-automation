describe Subscription::Canceller do
  let(:canceller) { Subscription::Canceller.new(subscription) }
  let(:subscription) { create(:subscription) }
  
  describe '#cancel_immediately' do
    before do
      allow(canceller).to receive(:cancel_unshipped_crates)
      allow_any_instance_of(RecurlyAdapter::SubscriptionCancellationService).to receive(:cancel_immediately)
    end

    it "cancels recurly subscription immediately" do
      expect_any_instance_of(RecurlyAdapter::SubscriptionCancellationService).to receive(:cancel_immediately)
      
      canceller.cancel_immediately
    end

    it "updates subscription's status to 'canceled'" do
      allow_any_instance_of(RecurlyAdapter::SubscriptionCancellationService).to receive(:errors).and_return(nil)

      expect{ canceller.cancel_immediately }.to change(subscription, :subscription_status).from('active').to('canceled')
    end

    it "cancels an unshipped crate" do
      allow_any_instance_of(RecurlyAdapter::SubscriptionCancellationService).to receive(:errors).and_return(nil)

      canceller.cancel_immediately

      expect(canceller).to have_received(:cancel_unshipped_crates)
    end

    context "when it fails to cancel_immediately" do
      
      let(:errors) { double('errors', full_messages: ['test error'])}
      
      it "adds cancel_immediately error" do
        allow_any_instance_of(RecurlyAdapter::SubscriptionCancellationService).to receive(:errors).and_return(errors)

        canceller.cancel_immediately

        expect(canceller.errors[:cancellation_error]).to_not be_empty
      end
    end
  end

  describe '#cancel_at_end_of_period' do
    before do
      allow_any_instance_of(RecurlyAdapter::SubscriptionCancellationService).to receive(:cancel_at_end_of_period)
      allow_any_instance_of(RecurlyAdapter::SubscriptionCancellationService).to receive(:subscription_expiration_date).and_return(Date.today)
    end

    it 'cancels recurly subscription' do
      expect_any_instance_of(RecurlyAdapter::SubscriptionCancellationService).to receive(:cancel_at_end_of_period)
      
      canceller.cancel_at_end_of_period
    end

    it "updates subscription's cancel_at_end_of_period to true" do
      expect{ canceller.cancel_at_end_of_period }.to change(subscription, :cancel_at_end_of_period).to(true)
    end

    it 'queues cancel_at_end_of_period email' do
      expect{
        canceller.cancel_at_end_of_period
      }.to change(SubscriptionWorkers::CancellationEmail.jobs, :size).by(1)
    end
    
    it 'queues email list status updater' do
      expect{
        canceller.cancel_at_end_of_period
      }.to change(SubscriptionWorkers::EmailListStatusUpdater.jobs, :size).by(1)
    end

    it "sets the latest version's event name to 'initiated pending cancellation'", versioning: true do
      canceller.cancel_at_end_of_period
      version = subscription.versions.last
      expect(version.event).to eq 'initiated pending cancellation'
    end

    context 'when cancellation fails' do
      let(:errors) { double('errors', full_messages: ['test error'])}
      before do
        allow_any_instance_of(RecurlyAdapter::SubscriptionCancellationService).to receive(:errors).and_return(errors)
      end
      
      it "adds cancel_at_end_of_period error" do
        canceller.cancel_at_end_of_period

        expect(canceller.errors[:cancellation_error]).to_not be_empty
      end

      it "creates an Airbrake notification" do
        expect(Airbrake).to receive(:notify)

        canceller.cancel_at_end_of_period
      end
    end
  end

  describe '#remove_cancel_at_end_of_period' do
    let(:cancellation_service) do
      instance_double(RecurlyAdapter::SubscriptionCancellationService,
                      remove_cancel_at_end_of_period: true,
                      errors: double('error', presence: false)
                     )
    end
    before do
      allow(RecurlyAdapter::SubscriptionCancellationService).to receive(:new).and_return(cancellation_service)
      subscription.update_attributes(cancel_at_end_of_period: true)
    end

    it 'reactivates recurly subscription' do
      canceller.remove_cancel_at_end_of_period

      expect(cancellation_service).to have_received(:remove_cancel_at_end_of_period)
    end

    it "updates subscription's cancel_at_end_of_period to nil" do
      expect{ canceller.remove_cancel_at_end_of_period
              subscription.reload
      }.to change(subscription, :cancel_at_end_of_period).to(nil)
    end

    it 'queues remove_cancel_at_end_of_period email' do
      expect{
        canceller.remove_cancel_at_end_of_period
      }.to change(SubscriptionWorkers::RemoveCancellationEmail.jobs, :size).by(1)
    end
    
    it 'queues email list status updater' do
      expect{
        canceller.remove_cancel_at_end_of_period
      }.to change(SubscriptionWorkers::EmailListStatusUpdater.jobs, :size).by(1)
    end

    it "sets the latest version's event name to 'removed pending cancellation'", versioning: true do
      canceller.remove_cancel_at_end_of_period

      version = subscription.versions.last

      expect(version.event).to eq 'removed pending cancellation'
    end

    context 'when reactivation fails' do
      let(:errors) { double('errors', full_messages: ['test error'])}
      before do
        allow(cancellation_service).to receive(:errors).and_return(errors)
      end
      
      it "adds cancellation_error" do
        canceller.remove_cancel_at_end_of_period

        expect(canceller.errors[:cancellation_error]).to_not be_empty
      end
    end
  end
end
