# Organizes all Error objects for the billing address update page,
# without doing any actual validation. At some point merge this code
# with the PaymentProfile form object in app/forms/payment_profile.rb.
#
class PaymentProfileError < Forms::Error
  include BillingInfoServiceInjector

  def initialize(*objects)
    super
    @failure_message = 'prevented your billing information from being updated.'
  end
end
