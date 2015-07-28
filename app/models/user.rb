class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  before_save :update_list_manager, if: :email_changed?
  has_many :subscriptions, -> { order('created_at DESC') }, inverse_of: :user do
    def oldest_active
      active.last
    end
  end
  has_many :billing_addresses, through: :subscriptions

  has_many :chargify_customer_accounts, class_name: 'ChargifyCustomer'
  has_many :recurly_accounts
  has_one :campaign_conversion
  has_many :store_credits, class_name: 'StoreCredit',
  foreign_key: 'referrer_user_id', dependent: :destroy
  has_many :friendbuy_conversion_events, class_name: 'FriendbuyConversionEvent',
  foreign_key: 'share_customer_id', dependent: :destroy
  # has_many :friendbuy_conversion_events, class_name: "FriendbuyConversionEvent",
  #   foreign_key: "email",
  #   primary_key: "email",
  #   dependent:   :destroy

  accepts_nested_attributes_for :subscriptions, allow_destroy: :true, reject_if: proc { |attrs| attrs.all? { |_k, v| v.blank? } }
  accepts_nested_attributes_for :campaign_conversion

  delegate :utm_campaign, to: :campaign_conversion, prefix: true
  delegate :utm_medium, to: :campaign_conversion, prefix: true
  delegate :utm_source, to: :campaign_conversion, prefix: true

  # before_destroy :cancel_subscription
  after_initialize :init

  has_paper_trail only: [:email]

  def init
    # I question this logic... seems like status here should be "created" (something  that doesn't imply an active subscription). Of course, creating a sub would need to update this field, instead of relying on the default value. (Patrick 20141208)
    self.account_status ||= 'active' if new_record?
  end

  def cancel_subscription
  end

  def expire
    UserMailer.expire_email(self).deliver
    destroy
  end

  # Scopes
  def admin?
    self.has_role? :admin
  end

  def store_credits
    StoreCredit.where('referrer_user_id = ? OR referrer_user_email = ?', id, email)
  end

  def redeemed_store_credits
    store_credits.redeemed
  end

  # Returns true if the subscriber is new
  #
  # If subscriber has only one subscription, then he or she is considered
  # new.  If subscriber has more than one, then they are considered returning
  def is_new_subscriber?
    subscriptions.count == 1
  end

  # from https://github.com/plataformatec/devise/wiki/How-To:-Migration-legacy-database
  def valid_password?(password)
    if spree_password_hash.present?
      if valid_spree_password?(password)
        self.password = password
        self.spree_password_hash = nil
        self.spree_password_salt = nil
        self.save!
        true
      else
        false
      end
    else
      super
    end
  end

  def valid_spree_password?(password)
    return false if spree_password_hash.blank?

    candidate = Devise::Encryptable::Encryptors::AuthlogicSha512.digest(password, 20, spree_password_salt, nil)
    candidate == spree_password_hash
  end

  def reset_password!(*args)
    self.spree_password_hash = nil
    super
  end

  def self.reset_password_token
    # some goofy devise changes occurred: https://github.com/plataformatec/devise/commit/143794d701bcd7b8c900c5bb8a216026c3c68afc
    #http://stackoverflow.com/questions/21844896/nomethoderror-undefined-method-reset-password-token-for-userclass
    raw, enc = Devise.token_generator.generate(User, :reset_password_token)
    raw
  end

  # Generates reset password and confirmation tokens
  def generate_legacy_invite_tokens
    # reset_password_token
    reset_password_token = User.reset_password_token
    reset_password_sent_at = Time.now.utc.to_s
    account_status = 'invited'
    save
  end

  def is_active?
    # chargify_customer_accounts.each do |chargify_customer|
    #   ChargifySwapper.set_chargify_site_for(chargify_customer)

    #   customer = Local::Chargify::Customer.find_by_id(chargify_customer.chargify_customer_id)
    #   stati = customer.subscriptions.map(&:state)
    #   # puts "#{customer.email} -> #{stati}"

    #   true if stati.include?('active')
    # end
    # # if you reach here, there were no active accounts found
    # false
    self.subscriptions.active.count > 0
  end

  def find_or_create_chargify_customer
    if chargify_customer_accounts.blank?
      ChargifySwapper.set_chargify_site_to_braintree
      chargify_customer = Local::Chargify::Customer.new(self).create
      cc_local = ChargifyCustomer.create(braintree: true, chargify_customer_id: chargify_customer.id)
      chargify_customer_accounts << cc_local
    else
      ChargifySwapper.set_chargify_site_for(subscriptions.last)
      chargify_customer = Local::Chargify::Customer.find_by_id(subscriptions.last.customer_id)
    end
    chargify_customer
  end

  def save_utm(cookies)
    return nil if cookies.nil?
    return nil if cookies['lc_utm'].blank? || cookies['lc_utm']['utm_campaign'].blank?

    utm_hash = parse_utm(cookies)
    create_campaign_conversion(utm_hash)
    cookies['lc_utm'] = nil
  end

  def send_reset_password_instructions
    token = set_reset_password_token
    self.reset_password_sent_at = Time.now.utc

    AccountWorkers::ResetPasswordEmail.perform_async(id, token, {}) if save(validate: false)
  end

  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first_or_create
    user.provider = auth.provider
    user.email = auth.info.email unless user.email?
    user.uid = auth.uid unless user.uid?
    user.password = Devise.friendly_token[0, 20] if user.new_record?
    user.full_name = auth.info.name unless user.full_name?
    user.save

    user
  end

  def emails
    version = self
    emails  = []

    until version.nil?
      emails << version.email

      version = version.previous_version
    end

    emails.uniq
  end

  def get_zendesk_tickets
    zendesk_client = Zendesk::API.instance
    tickets = []

    emails.each do |email|
      result = zendesk_client.search_tickets_by_email(email)

      tickets << result.fetch
    end

    tickets.flatten
  end

  def oldest_active_subscription
    subscriptions.oldest_active
  end

  def has_store_credit?
    store_credits.present?
  end

  def total_store_credits
    store_credits.total_available_store_credits
  end

  def update_list_manager
    AccountWorkers::EmailUpdateWorker.perform_async(email_was, email)
  end

  private

    def parse_utm(cookies)
      utm_json = JSON.parse(cookies['lc_utm'])
      {
        utm_campaign: utm_json['utm_campaign'],
        utm_medium: utm_json['utm_medium'],
        utm_source: utm_json['utm_source']
      }
    end
end
