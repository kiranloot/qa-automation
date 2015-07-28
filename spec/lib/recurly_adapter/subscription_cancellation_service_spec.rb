describe RecurlyAdapter::SubscriptionCancellationService do
  let(:subscription) { double('Subscription', recurly_subscription_id: 123) }
  let(:service) { RecurlyAdapter::SubscriptionCancellationService.new(subscription) }
  let(:recurly_sub) { double('recurly_sub') }
  before do
    allow(Recurly::Subscription).to receive(:find).and_return(recurly_sub)
  end

  describe '#cancel_immediately' do
    it 'immediately cancels recurly subscription' do
      expect(recurly_sub).to receive(:terminate).and_return(true)
      
      service.cancel_immediately
    end

    context 'when cancellation fails' do
      it 'adds an error to errors hash' do
        allow(recurly_sub).to receive(:terminate).and_raise('Timeout')

        service.cancel_immediately

        expect(service.errors[:cancel_immediately]).to_not be_empty
      end
    end
  end

  describe '#cancel_at_end_of_period' do
    it 'turns off auto-renewal for recurly subscription' do
      expect(recurly_sub).to receive(:cancel).and_return(true)

      service.cancel_at_end_of_period
    end

    context 'when cancellation fails' do
      it 'adds an error to errors hash' do
        allow(recurly_sub).to receive(:cancel).and_raise('Timeout')

        service.cancel_at_end_of_period

        expect(service.errors[:cancel_at_end_of_period]).to_not be_empty
      end
    end
  end

  describe '#remove_cancel_at_end_of_period' do
    it 'turns on auto-renewal for recurly subscription' do
      allow(recurly_sub).to receive(:reactivate).and_return(true)

      service.remove_cancel_at_end_of_period

      expect(recurly_sub).to have_received(:reactivate)
    end

    context 'when reactivation fails' do
      it 'adds an error to errors hash' do
        allow(recurly_sub).to receive(:reactivate).and_raise('Timeout')

        service.remove_cancel_at_end_of_period

        expect(service.errors[:remove_cancel_at_end_of_period]).to_not be_empty
      end
    end
  end

  describe '#subscription_expiration_date' do
    it 'returns the recurly subscription "expires at" date' do
      expect(recurly_sub).to receive(:expires_at).and_return(Date.today)

      service.subscription_expiration_date
    end
  end
end
