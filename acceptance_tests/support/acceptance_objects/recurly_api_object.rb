require 'recurly'

class RecurlyAPI
  include RSpec::Matchers
  def initialize
    Recurly.api_key = '05a550e0a0b24b3bbb27e2b3d126e09c'
    Recurly.subdomain = 'lootcrate-sandbox'
    @user = $test.user
    @recurly_account_id = $test.db.get_recurly_account_id(@user.email)
    @account = Recurly::Account.find(@recurly_account_id)
  end

  def verify_subscription_type
    expect($test.user.subscription_name).to eq(@account.subscriptions.last.plan.name)  
  end

  def verify_next_bill_date
    #TODO
  end

  def verify_no_subscriptions
    expect(@account.subscriptions.count).to eq(0)
  end
end