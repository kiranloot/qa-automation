class StoreCredit < ActiveRecord::Base
  # FIXME: NICETOHAVE This causes a loop
  # belongs_to :referrer_user, class_name: "User", foreign_key: "referrer_user_id"
  # belongs_to :referred_user, class_name: "User", foreign_key: "referred_user_id"

  scope :pendings, -> { where(status: 'pending') }
  scope :actives, -> { where(status: 'active') }
  scope :not_redeemed, -> { where(status: ['pending', 'active']) }
  scope :redeemed, -> { where(status: 'redeemed') }

  validates :friendbuy_conversion_id, uniqueness: true
  validates_presence_of :amount

  def in_cents
    (amount * 100).to_i
  end

  def credit_referrer
    return false unless redeemable?
    if referrer_user.nil? # or the user does not have an oldest active subscription
      self.update_attributes!(status: 'active')
    else
      redeem
    end
  end

  def redeem(subscription=referrer_user.oldest_active_subscription)
    begin
      ChargifyAdapter::AdjustmentService.new(subscription, -(in_cents),
        memo: "store_credit_#{self.id}").create
      # update store credit status
      self.update_attributes!(status: 'redeemed')
    rescue => e
      Airbrake.notify(
       :error_class      => "Processing Store Credit Error:",
        :error_message    => "Failed to make an adjustment: #{e}",
        :backtrace        => $@,
        :environment_name => ENV['RAILS_ENV']
      )
    end
  end

  # Get referrer in our DB
  # returns referrer user if he
  def referrer_user
    @referrer_user = @referrer_user || (User.find_by_id(referrer_user_id) ||
                                        User.find_by_email(referrer_user_email))
  end

  def referred_user
    @referred_user ||= User.find_by_id(referred_user_id)
  end

  class << self
    # Grabs all store credits that has not been redeemed yet
    def total_available_store_credits
      not_redeemed.map(&:amount).reduce(0,:+).round(2)
    end
  end

end
