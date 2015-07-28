require 'spec_helper'

describe Forms::Error do
  before(:each) do
    billing_address = FactoryGirl.build(:billing_address, first_name: nil)
    credit_card = FactoryGirl.build(:credit_card, number: nil)
    billing_address.valid?
    credit_card.valid?
    @forms_error = Forms::Error.new(billing_address, credit_card)
  end

  it 'creates a default failure message' do
    expect(@forms_error.failure_message).to include("prevented your form from being accepted.")
  end

  it 'generates a #summary with the number of errors' do
    expect(@forms_error.summary).to include("2 Errors prevented your form from being accepted.")
  end

  it 'generates details of unprocessable base error messages in #summary' do
    @forms_error.objects.first.errors.add(:base, "test")
    expect(@forms_error.summary).to include("3 Errors prevented your form from being accepted.<br/><br/><ul><li>test</li></ul>")
  end
end
