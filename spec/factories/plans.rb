FactoryGirl.define do
  # These plans are for US.
  factory :plan do
    name '1-month-subscription'
    initialize_with { Plan.find_or_create_by(name: name) }
    cost 19.37
    period 1
    shipping_and_handling 6.0
    savings_copy "you save"
    country 'US'

    factory :plan_3_months do
      name '3-month-subscription'
      cost 55.11
      period 3
    end

    factory :plan_6_months do
      name '6-month-subscription'
      cost 105.99
      period 6
    end

    factory :plan_12_months do
      name '12-month-subscription'
      cost 215.40
      period 12
    end

    trait :legacy_1_month do
      name '1-month-subscription-v1'
      cost 19.37
      period 1
    end

    trait :legacy_3_month do
      name '3-month-subscription-v1'
      cost 55.11
      period 3
    end

    trait :legacy_6_month do
      name '6-month-subscription-v1'
      cost 105.99
      period 12
    end

  end

  factory :plan_au, class: Plan do
    name 'au-1-month-subscription'
    initialize_with { Plan.find_or_create_by(name: name)}
    cost 29.95
    period 1
    shipping_and_handling 0.0
    country 'AU'

    factory :plan_au_3_months do
      name 'au-3-month-subscription'
      cost 84.00
      period 3
    end

    factory :plan_au_6_months do
      name 'au-6-month-subscription'
      cost 162.00
      period 6
    end
  end

  factory :plan_ca, class: Plan do
    name 'ca-1-month-subscription'
    initialize_with { Plan.find_or_create_by(name: name)}
    cost 29.95
    period 1
    shipping_and_handling 0.0
    country 'CA'

    factory :plan_ca_3_months do
      name 'ca-3-month-subscription'
      cost 84.00
      period 3
    end

    factory :plan_ca_6_months do
      name 'ca-6-month-subscription'
      cost 162.00
      period 6
    end
  end

  factory :plan_gb, class: Plan do
    name 'gb-1-month-subscription'
    initialize_with { Plan.find_or_create_by(name: name)}
    cost 29.95
    period 1
    shipping_and_handling 0.0
    country 'GB'

    factory :plan_gb_3_months do
      name 'gb-3-month-subscription'
      cost 84.00
      period 3
    end

    factory :plan_gb_6_months do
      name 'gb-6-month-subscription'
      cost 162.00
      period 6
    end
  end

  factory :plan_de, class: Plan do
    name 'de-1-month-subscription'
    initialize_with { Plan.find_or_create_by(name: name)}
    cost 29.95
    period 1
    shipping_and_handling 0.0
    country 'DE'

    factory :plan_de_3_months do
      name 'de-3-month-subscription'
      cost 84.00
      period 3
    end

    factory :plan_de_6_months do
      name 'de-6-month-subscription'
      cost 162.00
      period 6
    end
  end

  factory :plan_dk, class: Plan do
    name 'dk-1-month-subscription'
    initialize_with { Plan.find_or_create_by(name: name)}
    cost 29.95
    period 1
    shipping_and_handling 0.0
    country 'DK'

    factory :plan_dk_3_months do
      name 'dk-3-month-subscription'
      cost 84.00
      period 3
    end

    factory :plan_dk_6_months do
      name 'dk-6-month-subscription'
      cost 162.00
      period 6
    end
  end

  factory :plan_ie, class: Plan do
    name 'ie-1-month-subscription'
    initialize_with { Plan.find_or_create_by(name: name)}
    cost 29.95
    period 1
    shipping_and_handling 0.0
    country 'IE'

    factory :plan_ie_3_months do
      name 'ie-3-month-subscription'
      cost 84.00
      period 3
    end

    factory :plan_ie_6_months do
      name 'ie-6-month-subscription'
      cost 162.00
      period 6
    end
  end

  factory :plan_nl, class: Plan do
    name 'nl-1-month-subscription'
    initialize_with { Plan.find_or_create_by(name: name)}
    cost 29.95
    period 1
    shipping_and_handling 0.0
    country 'NL'

    factory :plan_nl_3_months do
      name 'nl-3-month-subscription'
      cost 84.00
      period 3
    end

    factory :plan_nl_6_months do
      name 'nl-6-month-subscription'
      cost 162.00
      period 6
    end
  end

  factory :plan_no, class: Plan do
    name 'no-1-month-subscription'
    initialize_with { Plan.find_or_create_by(name: name)}
    cost 29.95
    period 1
    shipping_and_handling 0.0
    country 'NO'

    factory :plan_no_3_months do
      name 'no-3-month-subscription'
      cost 84.00
      period 3
    end

    factory :plan_no_6_months do
      name 'no-6-month-subscription'
      cost 162.00
      period 6
    end
  end

  factory :plan_se, class: Plan do
    name 'se-1-month-subscription'
    initialize_with { Plan.find_or_create_by(name: name)}
    cost 29.95
    period 1
    shipping_and_handling 0.0
    country 'SE'

    factory :plan_se_3_months do
      name 'se-3-month-subscription'
      cost 84.00
      period 3
    end

    factory :plan_se_6_months do
      name 'se-6-month-subscription'
      cost 162.00
      period 6
    end
  end

  factory :plan_fi, class: Plan do
    name 'fi-1-month-subscription'
    initialize_with { Plan.find_or_create_by(name: name)}
    cost 29.95
    period 1
    shipping_and_handling 0.0
    country 'FI'

    factory :plan_fi_3_months do
      name 'fi-3-month-subscription'
      cost 84.00
      period 3
    end

    factory :plan_fi_6_months do
      name 'fi-6-month-subscription'
      cost 162.00
      period 6
    end
  end

  factory :plan_fr, class: Plan do
    name 'fr-1-month-subscription'
    initialize_with { Plan.find_or_create_by(name: name)}
    cost 29.95
    period 1
    shipping_and_handling 0.0
    country 'FR'

    factory :plan_fr_3_months do
      name 'fr-3-month-subscription'
      cost 84.00
      period 3
    end

    factory :plan_fr_6_months do
      name 'fr-6-month-subscription'
      cost 162.00
      period 6
    end
  end

  factory :plan_nz, class: Plan do
    name 'nz-1-month-subscription'
    initialize_with { Plan.find_or_create_by(name: name)}
    cost 29.95
    period 1
    shipping_and_handling 0.0
    country 'NZ'

    factory :plan_nz_3_months do
      name 'nz-3-month-subscription'
      cost 84.00
      period 3
    end

    factory :plan_nz_6_months do
      name 'nz-6-month-subscription'
      cost 162.00
      period 6
    end
  end

  factory :int_plan, class: Plan do
    name   "ca-1-month-subscription"
    cost   "29.95"
    period "1"
    shipping_and_handling "0.0"
  end

  factory :sock_plan, class: Plan do
    name                  "lc-lu01-01-us"
    cost                  "10.00"
    period                1
    shipping_and_handling 0.0
    savings_copy          "Cancel Anytime"
    country "US"
  end
end
