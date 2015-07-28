describe RecurlyAdapter::PostponementService do
  describe '#postpone' do
    let(:subscription) { create(:subscription) }
    it 'calls Recurly postpone api' do
      recurly_sub = double('recurly_sub')
      date = Date.today + 1.day
      allow(Recurly::Subscription).to receive(:find).and_return(recurly_sub)
      expect(recurly_sub).to receive(:postpone).with(date)

      RecurlyAdapter::PostponementService.new(subscription).readjust_rebilling_date(date)
    end

    context 'postpone a subscription to the past' do
      it 'does not call gateway' do
        recurly_sub = double('recurly_sub')
        postponement_service = RecurlyAdapter::PostponementService.new(subscription)
        allow(Recurly::Subscription).to receive(:find).and_return(recurly_sub)
        expect(recurly_sub).to_not receive(:postpone)

        postponement_service.readjust_rebilling_date(Date.today - 1.day)
      end

      it 'sets error' do
        recurly_sub = double('recurly_sub')
        allow(Recurly::Subscription).to receive(:find).and_return(recurly_sub)

        postponement_service = RecurlyAdapter::PostponementService.new(subscription)
        postponement_service.readjust_rebilling_date(Date.today - 1.day)
        expect(postponement_service.errors).to_not be_empty
      end
    end

    context 'cannot find subscription' do
      it 'adds to errors' do
        allow(Recurly::Subscription).to receive(:find).and_raise(StandardError, "Not Found")

        postponement_service = RecurlyAdapter::PostponementService.new(subscription)
        postponement_service.readjust_rebilling_date(Date.today - 1.day)
        expect(postponement_service.errors.messages[:postponement_service]).to_not be_empty
      end
    end
  end

end
