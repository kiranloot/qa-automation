describe ShippingAddress::Changer do

  let(:subscription) { create(:subscription) }
  let(:shipping_address) { build(:random_shipping_address) }
  let(:shipping_address_params) do
    {
      first_name: shipping_address.first_name,
      last_name:  shipping_address.last_name,
      line_1:     shipping_address.line_1,
      line_2:     shipping_address.line_2,
      city:       shipping_address.city,
      state:      shipping_address.state,
      zip:        shipping_address.zip,
      country:    shipping_address.country
    }
  end
  let(:shipping_address_changer) { ShippingAddress::Changer.new(subscription.shipping_address, subscription, shipping_address_params) }
  let(:shipping_address_service) { instance_double(RecurlyAdapter::ShippingAddressService) }
  before do
    allow(RecurlyAdapter::ShippingAddressService).to receive(:new).and_return(shipping_address_service)
  end


  describe '#perform' do
    before do
      allow(shipping_address_service).to receive(:update)
    end

    it 'updates shipping address' do
      shipping_address_changer.perform

      expect(subscription.shipping_address.first_name).to eq shipping_address.first_name
      expect(subscription.shipping_address.last_name).to eq shipping_address.last_name
      expect(subscription.shipping_address.line_1).to eq shipping_address.line_1
      expect(subscription.shipping_address.line_2).to eq shipping_address.line_2
      expect(subscription.shipping_address.city).to eq shipping_address.city
      expect(subscription.shipping_address.state).to eq shipping_address.state
      expect(subscription.shipping_address.zip).to eq shipping_address.zip
      expect(subscription.shipping_address.country).to eq shipping_address.country
    end
    it 'updates recurly' do
      shipping_address_changer.perform

      expect(shipping_address_service).to have_received(:update)
    end

    context "shipping address is invalid" do
      let(:error_key) { :error_key }
      let(:error_message) { 'test error message' }
      before do
        allow(subscription.shipping_address).to receive(:valid?).and_return(false)
        subscription.shipping_address.errors.add( error_key, error_message )
      end

      it 'does not update shipping address' do
        old_line_1 = subscription.shipping_address.line_1
        shipping_address_changer.perform

        expect(subscription.reload.shipping_address.line_1).to eq old_line_1
      end
      it 'does not update recurly' do
        shipping_address_changer.perform

        expect(shipping_address_service).to_not have_received(:update)
      end
    end

    context "recurly update fails" do
      before do
        allow(shipping_address_service).to receive(:update).and_raise(StandardError, "Recurly Error")
      end

      it "does not update shipping address record" do
        old_line_1 = subscription.shipping_address.line_1
        begin
          shipping_address_changer.perform
        rescue
        end

        expect(subscription.reload.shipping_address.line_1).to eq old_line_1
      end
    end
  end
end
