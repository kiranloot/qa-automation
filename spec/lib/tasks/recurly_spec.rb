RSpec.describe 'recurly' do
  include_context 'rake'

  describe 'promotions:initialize' do
    before { (1..100).each { create :promotion }}
    subject { rake['recurly:promotions:initialize'] }

    it { expect(subject.prerequisites).to include('environment') }

    it 'calls RecurlyWorkers::CouponWorker.perform_async for each promotion' do
      allow(RecurlyWorkers::CouponWorker).to receive(:perform_async)
      Promotion.order('created_at').each do |promotion|
        expect(RecurlyWorkers::CouponWorker).to receive(:perform_async).with(promotion.id).ordered
      end

      subject.invoke
    end
  end
end
