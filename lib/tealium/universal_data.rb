module Tealium
  class UniversalData
    attr_accessor :page_type, :page_name, :country_code, :environment, :convertro_event_type

    def initialize(options={})
      @page_type = remap_page_type(options[:page_type])|| 'UNDEFINED' # REQUIRED
      @page_name = options[:page_name] || get_page_name_from_type(options[:page_type])
      @site_section = options[:site_section] || 'UNDEFINED'
      @subscription = options[:subscription]
      @user = options[:user]
      @country_code = options[:country_code]
      @environment = establish_current_environment
      @convertro_event_type = options[:convertro_event_type]
    end

    def get_page_name_from_type(page_type=nil)
      return 'UNDEFINED' if page_type.nil?

      case page_type.downcase
      when 'welcome_index'
        'homepage'
      when 'how_it_works_index'
        'how_it_works'
      when 'past_crates_index'
        'past_crates'
      when 'subscriptions_index'
        'join'
      when 'user_accounts_index'
        'user_accounts'
      when 'subscriptions_new'
        'subscription_order_page'
      when 'payment_completed_index'
        'order_completed'
      else
        page_type.humanize
      end
    end

    def remap_page_type(page_type = nil)
      return 'UNDEFINED' if page_type.blank?
      case page_type.downcase
      when 'welcome_index'
        'home'
      when 'how_it_works_index'
        'section'
      when 'past_crates_index'
        'section'
      when 'subscriptions_index'
        'section'
      when 'user_accounts_index'
        'account'
      when 'subscriptions_new'
        'checkout'
      when 'payment_completed_index'
        'order'
      else
        page_type
      end
    end

    def has_subscription?
      @subscription.present?
    end

    def has_user_info?
      !@user.nil?
    end

    def order_json
      {
        order_id: order_id,
        order_grand_total: order_grand_total,
        order_shipping_amount: order_shipping_amount,
        country_code: @country_code,
        order_subtotal: order_subtotal,
        order_discount_amount: order_discount_amount,
        order_tax_amount: order_tax_amount
      }.to_json
    end

    def user_json
      {
        customer_id: "#{@user.id}",
        customer_email: @user.email
      }.to_json
    end

    # Get current environment and map to tealium's environment
    def establish_current_environment
      case Rails.env
      when 'development'
        'dev'
      when 'staging'
        'qa'
      when 'production'
        'prod'
      else
        'qa'
      end
    end

  end # of class
end # of module
