require 'spec_helper'

RSpec.describe RecurlyWorkers::MoveRebillDate do
  it "updates recurly's subscription to a new plan on renewal" do
    worker             = RecurlyWorkers::MoveRebillDate.new
    recurly_sub        = double('recurly_sub', postpone: true)
    next_assessment_at = DateTime.now
    allow(Recurly::Subscription).to receive(:find) { recurly_sub }

    worker.perform('100a', next_assessment_at)

    expect(recurly_sub).to have_received(:postpone).with(next_assessment_at)
  end
end