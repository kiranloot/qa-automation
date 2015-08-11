require 'recurly'

class RecurlyAPI
  include RSpec::Matchers
  def initialize
    Recurly.api_key = '05a550e0a0b24b3bbb27e2b3d126e09c'
    Recurly.subdomain = 'lootcrate-sandbox'        
  end

  def get_account
    user = $test.user
    recurly_account_id = $test.db.get_recurly_account_id(user.email)
    account = Recurly::Account.find(recurly_account_id)
  end

  def verify_subscription_type
    account = get_account
    expect(account.subscriptions.last.plan.name).to eq($test.user.subscription_name)  
  end

  def verify_next_bill_date
    #TODO
  end

  def verify_no_subscriptions
    account = get_account
    expect(account.subscriptions.count).to eq(0)
  end

  def verify_level_up_subscription (months,product)
    account = get_account
    numMonths = get_months(months)
    expect(account.subscriptions.first.plan.name.match(/#{product}.*#{numMonths} month/i)).not_to be_nil
  end

  def verify_subscription_upgrade (months)
    account = get_account
    newPlan = "#{get_months(months)} Month Subscription"
    expect(account.subscriptions.last.pending_subscription.plan.name).to eq(newPlan)  
  end
  def verify_status(status)
    account = get_account
    expect(account.subscriptions.first.state).to eq(status)
  end

  def verify_reactivated
    account = get_account
    expect(account.subscriptions.first.state).to eq("active")
  end

  def verify_billing
    expect(account.address[:address1]).to eq($test.user.bill_street)
    expect(account.address[:address2]).to eq($test.user.bill_street2)
    expect(account.address[:city]).to eq($test.user.bill_city)
    expect(account.address[:zip]).to eq($test.user.bill_zip)
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
end