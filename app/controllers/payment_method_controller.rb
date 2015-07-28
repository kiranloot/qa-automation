class PaymentMethodController < ApplicationController
    force_ssl if: :ssl_configured?
    before_filter :authenticate_user!
    respond_to :html, :json

    def update
      @billing_information = Forms::BillingInformation.new(params, payment_method_params, current_user)
      @subscription        = @billing_information.subscription

      respond_to do |format|
        format.js do
          @error_messages = @billing_information.error_summary unless @billing_information.update
        end
      end
    end

    private

    def payment_method_params
      params.require(:payment_method).permit(:full_name, credit_card: [ :number, :cvv, 'expiration(3i)', 'expiration(2i)', 'expiration(1i)'])
    end
end
