require 'recurly'

class RecurlyAPI
  include RSpec::Matchers
  def initialize(box)
    Recurly.api_key = box.recurly_api_key
    Recurly.subdomain = box.recurly_subdomain
  end

  def get_account
    user = $test.user
    recurly_account_id = $test.db.get_recurly_account_id(user.email)
    account = Recurly::Account.find(recurly_account_id)
  end

  def get_last_invoice_for_account
    get_account.invoices.first
  end

  def verify_subscription_type(country_code = "US")
    #Do if this is a level up sub
    if $test.user.recurly_level_up_plan
      recurly_sub = $test.user.recurly_level_up_plan
      if country_code == "US"
        recurly_sub = recurly_sub + " - US"
      else
        recurly_sub = recurly_sub + " - Intl"
      end
    #do if this is any other sub
    else
      if $test.user.subscription_name.include? '1 Year Subscription'
        recurly_sub = $test.user.subscription_name.gsub(/1 Year/, "12 Month")
      elsif $test.user.crate_type == "Firefly"
        recurly_sub = 'Firefly ' + $test.user.subscription_name
      else
        recurly_sub = $test.user.subscription_name
      end
      unless country_code == "US"
        country_code[1] = country_code[1].downcase
        recurly_sub = country_code + " " + recurly_sub
      end
    end
    account = get_account
    #remove the word "Plan" from the validation
    recurly_sub = recurly_sub.gsub(/Plan /,"")
    expect(account.subscriptions.first.plan.name).to eq(recurly_sub)
  end

  def verify_level_up_subscription (months,product)
    account = get_account
    numMonths = get_months(months)
    expect(account.subscriptions.first.plan.name.match(/#{product}.*#{numMonths} month/i)).not_to be_nil
  end

  def verify_subscription_upgrade (months)
    account = get_account
    newPlan = "#{get_months(months)} Month Subscription"
    expect(account.subscriptions.first.pending_subscription.plan.name).to eq(newPlan)
  end

  def verify_status(status)
    account = get_account
    expect(account.subscriptions.first.state).to eq(status)
  end

  def verify_billing_address
    account = get_account
    info = account.billing_info
    expect(info[:address1]).to eq($test.user.billing_address.street)
    expect(info[:address2] || "").to eq($test.user.billing_address.street_2 || "")
    expect(info[:city]).to eq($test.user.billing_address.city)
    expect(info[:zip]).to eq($test.user.billing_address.zip)
  end

  def verify_billing_address_has_no_state
    account = get_account
    info = account.billing_info
    expect(info[:state]).to be(nil)
  end

  def verify_billing_address_has_state(state)
    account = get_account
    info = account.billing_info
    #expect(info[:state]).not_to be(nil)
    expect(info[:state]). to eq(state)
  end

  def verify_shipping_address
    account = get_account
    expect(account.address[:address1]).to eq($test.user.ship_street)
    expect(account.address[:address2] || "").to eq($test.user.ship_street_2 || "")
    expect(account.address[:city]).to eq($test.user.ship_city)
    expect(account.address[:zip]).to eq($test.user.ship_zip)
  end

  def verify_full_name
    account = get_account
    expect(account.billing_info.first_name).to eq($test.user.first_name)
    expect(account.billing_info.last_name).to eq($test.user.last_name)
  end

  def verify_cc_info
    account = get_account
    expect(account.billing_info.first_six).to eq($test.user.cc.to_s[0..5])
    expect(account.billing_info.last_four).to eq($test.user.last_four)
  end

  def get_subscription_info(account)
    account.subscriptions.first
  end

  def get_invoice_info(account)
    account.invoices.first
  end

  def get_billing_address
    account = get_account
    info = account.billing_info
    address = {address1: info[:address1],
               address2: info[:address2],
               city:    info[:city],
               state:   info[:state],
               zip:     info[:zip],
               country: info[:country]
              }
  end

  #Recurly billing_info address fields:
  # address1
  # address2
  # city
  # zip
  # state
  # country
  def update_billing_address(address_hash)
    account = get_account
    billing = account.billing_info
    address_hash.each do |key, value|
      billing[key] = value if billing.respond_to?(key)
    end
    billing.save
  end

  def get_rebill_date(with_tz_offset = -8.0/24)
    account = get_account
    account.subscriptions.first.current_period_ends_at.new_offset(with_tz_offset)
  end

  def get_status
    account = get_account
    account.subscriptions.first.state
  end

  def get_months (months)
    numMonths = 0
    case months

    when "one"
      numMonths = 1
    when "three"
      numMonths = 3
    when "six"
      numMonths = 6
    when "twelve"
      numMonths = 12
    end
    numMonths
  end

  def get_coupon_info(code)
    Recurly::Coupon.find(code)
  end

  def update_next_renewal_date(minutes = 1)
    account = get_account
    sub = account.subscriptions.first
    adjusted_rebill_date = Time.new + minutes * 60
    account.subscriptions.first.postpone(adjusted_rebill_date)
    $test.user.new_rebill_date = get_rebill_date
  end

  def account_has_invoices?(amount)
    expect(get_account.invoices.length).to eq(amount)
  end

  def change_account_cc_to(cc_number)
    account = get_account
    account.billing_info = {
      :number => cc_number
    }
    begin
      account.billing_info.save
    rescue Recurly::Transaction::DeclinedError => e
    end
  end

  def get_tax_info
    account = get_account
    invoice_data = account.invoices[0]['line_items']
    tax_info = {}
    tax_info['region'] = invoice_data['tax_region']
    tax_info['tax_total'] = invoice_data['tax_in_cents']
    tax_info
  end

  def get_upgrade_info
    account = get_account
    subscription = account.subscriptions.first
    upgrade_info = {}
    upgrade_info['rebill_date'] = subscription.current_period_ends_at
    upgrade_info['cost'] = subscription['pending_subscription']['unit_amount_in_cents']
    upgrade_info
  end

  def verify_rebill_date
    account = get_account
    #Conditional statement to handle the UTC date change by 4pm PST
    #if DateTime.now.strftime('%H').to_i >= 16
      #calculated_rebill_date = $test.calculate_rebill_date(true)
    #else
    calculated_rebill_date = $test.calculate_rebill_date
    #end
    #actual_rebill_date = get_subscription_info(account).current_period_ends_at.new_offset(-8.0/24)
    actual_rebill_date = get_rebill_date
    expect(actual_rebill_date.strftime('%Y')).to eq(calculated_rebill_date['year'])
    expect(actual_rebill_date.strftime('%B')).to eq(calculated_rebill_date['month'])
    expect(actual_rebill_date.strftime('%d')).to eq(calculated_rebill_date['day'])
  end
end
