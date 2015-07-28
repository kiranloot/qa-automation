FactoryGirl.define do
  factory :credit_card do
    number      '1'
    cvv         '111'
    expiration  Date.new(2030, 1, 31)

    initialize_with { new(attributes) }
  end

  factory :expired_credit_card, class: CreditCard do
    number     '1'
    cvv        '111'
    expiration Date.new(2012, 1, 31)
  end
end
