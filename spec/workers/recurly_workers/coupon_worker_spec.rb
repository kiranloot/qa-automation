require 'spec_helper'

RSpec.describe RecurlyWorkers::CouponWorker do
  it "updates recurly's subscription to a new plan on renewal" do
    promotion = create(:promotion)
    creator   = spy
    worker    = RecurlyWorkers::CouponWorker.new
    allow(RecurlyAdapter::CouponCreator).to receive(:new) { creator }

    worker.perform(promotion.id)

    expect(creator).to have_received(:fulfill)
  end
end
