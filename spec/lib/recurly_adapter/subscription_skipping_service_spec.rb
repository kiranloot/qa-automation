require 'spec_helper'

RSpec.describe RecurlyAdapter::SubscriptionSkippingService do
  let(:skipper) { RecurlyAdapter::SubscriptionSkippingService.new('1') }

  describe "#skip_a_month" do
    context "when successful" do
      it "returns true" do
        valid_skip_date = DateTime.now + 1.month
        sub = double('sub', postpone: true, current_period_ends_at: valid_skip_date)
        allow(Recurly::Subscription).to receive(:find) { sub }

        result = skipper.skip_a_month

        expect(sub).to have_received(:postpone)
        expect(result).to be true
      end
    end

    context "when it fails" do
      it "returns false" do
        invalid_skip_date = 1.month.ago
        sub = double('sub', current_period_ends_at: invalid_skip_date)
        allow(Recurly::Subscription).to receive(:find) { sub }
        allow(sub).to receive(:postpone) { raise('Error 404') }

        result = skipper.skip_a_month

        expect(result).to be false
      end
    end
  end
end