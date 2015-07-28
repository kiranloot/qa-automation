require 'sailthru'

module Sailthru
  # Manages the list on Sailthru
  class ListManager
    def initialize(user, options={})
      @user = user
      @email = user.email
      @vars = options[:vars] || {}
      @lists = options[:lists] || {}
      @data = options[:data] || {}
    end

    def subscribe_new_email
      add_to_master_list
      @vars.merge!(default_vars_for_new_newsletter_signup)
      send_user_data_to_sailthru
    end

    def default_vars_for_new_newsletter_signup
      {
        newsletter_signup_date: DateTime.now,
        subscription_status: 'not_subscribed',
        friendbuy_url: get_friendbuy_purl
      }
    end

    def subscribe_new_account
      add_to_master_list
      # Ideally we want to store via our user_id but unfortunately that
      # feature isn't built out yet for Sailthru - 2014/03/11
      @vars.merge!(default_vars_for_new_accounts)
      send_user_data_to_sailthru
    end

    def update_subscription_status
      add_to_master_list
      if user_active_subscriptions.present?
        @vars[:subscription_status] = 'active'
      else
        @vars[:subscription_status] = 'canceled'
        @vars[:cancellation_date] = DateTime.now
      end
      send_user_data_to_sailthru
    end

    # Update subscriber's information with new subscription
    def update_new_subscription
      # FYI might add to other lists in the future
      add_to_master_list
      subscription = sub_with_greatest_plan_period
      shipping_address = subscription.shipping_address
      @vars.merge!(
        shirt_size: subscription.shirt_size,
        subscription_length: subscription.plan_period,
        subscription_status: subscription.subscription_status,
        shipping_address: shipping_address.line_1,
        shipping_address_2: shipping_address.line_2,
        shipping_city: shipping_address.city,
        shipping_state: shipping_address.state,
        shipping_postal_code: shipping_address.zip,
        shipping_country: shipping_address.country,
        first_name: shipping_address.first_name,
        last_name: shipping_address.last_name
      )
      send_user_data_to_sailthru
    end

    private

    def sailthru_client
      @sailthru_client = @sailthru_client || Sailthru::Client.new(
        ENV['SAILTHRU_API_KEY'],
        ENV['SAILTHRU_API_SECRET'],
        ENV['SAILTHRU_API_URL']
      )
    end

    def send_user_data_to_sailthru
      @data = { id: @email, key: 'email', lists: @lists, vars: @vars }
      sailthru_client.api_post('user', @data)
    end

    def user_active_subscriptions
      @user.subscriptions.active.where(cancel_at_end_of_period: nil)
    end

    # customer_number = LC user.id
    def default_vars_for_new_accounts
      {
        customer_number: @user.id,
        email_signup_date: DateTime.now,
        subscription_status: 'not_subscribed',
        friendbuy_url: get_friendbuy_purl
      }
    end

    def get_friendbuy_purl
      fb = Friendbuy::API.new(customer_id: @user.email, campaign_id: ENV['FRIENDBUY_PURL_WIDGET_CAMPAIGN_ID'])
      fb.get_PURL
    end

    def add_to_master_list
      @lists['Loot Crate Master List'] = 1
    end

    def sub_with_greatest_plan_period
      active_subs = @user.subscriptions.active

      # get subscription with greatest plan period
      active_subs.sort_by(&:plan_period).last
    end
  end
end
