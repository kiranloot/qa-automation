require 'spec_helper'

RSpec.describe RecurlyWorkers::RemoveAdjustment do
  it "deletes an adjustment when one is found" do
    worker     = RecurlyWorkers::RemoveAdjustment.new
    adjustment = double('adjustment', destroy: true)
    allow(Recurly::Adjustment).to receive(:find).and_return(adjustment)
    
    worker.perform('100a')

    expect(adjustment).to have_received(:destroy)
  end
end