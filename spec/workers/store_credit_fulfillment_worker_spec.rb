require 'spec_helper'

describe StoreCreditFulfillmentWorker do
  describe '#perform' do
    context 'referred subscriber has a subscription' do
      context 'active subscription' do
        it 'creates an adjustment for the oldest active subscription' do
        end

        it 'fails to create an adjustment for the oldest active subscription' do
        end
      end

      context 'cancelled subscription' do
        it 'gives users active store credit for next subscription' do
        end
      end
    end

    context 'referred subscriber does not have a subscription' do
      it 'does nothing to store credit' do
      end
    end
  end
end
