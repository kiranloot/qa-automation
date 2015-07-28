module MailChimp
  class ListManager
    def initialize(user, options = {})
      @user            = user
      @email           = user.email
      @merge_vars      = options[:merge_vars] || {}
      @double_optin    = options[:double_optin] || false
      @update_existing = options[:update_existing] || false
    end

    def subscribe_new_account
      response = {}
      begin
        @merge_vars[:SUB_STATUS] = 'not_subscribed'
        @merge_vars[:FRIENDBUY] = get_friendbuy_PURL
        @merge_vars[:TEXT_PURL] = @merge_vars[:FRIENDBUY]
        @update_existing         = true

        response = lists.subscribe data
      rescue Exception => e
        Rails.logger.error "Unable to subscribe #{@email}. Reason: #{e}"
      end

      response
    end

    def update_subscription_status
      response = {}
      begin
        subscriptions = @user.subscriptions.presence

        active_subs = subscriptions.select do |s|
                        s.subscription_status == 'active' &&
                        s.cancel_at_end_of_period == nil
                      end

        if active_subs.present?
          @merge_vars[:SUB_STATUS] = 'active'
        else
          @merge_vars[:SUB_STATUS] = 'canceled'
        end

        @update_existing = true

        response = lists.update_member data
      rescue Gibbon::MailChimpError => e
        if unsubscribed_from_list_message?(e.message) || no_record_of_email_message?(e.message)
          {}
        else
          raise e
        end
      rescue => e
        Rails.logger.error "Unable to update #{@email}. Reason: #{e}"
      end

      response
    end

    # Update subscriber's information with new subscription.
    def update_new_subscription
      response = {}
      begin
        active_subs = @user.subscriptions.where(subscription_status: 'active')

        # Get subscription with greatest plan period.
        subscription = active_subs.sort_by {|s| s.plan.period }.last

        @merge_vars[:SHIRT_SIZE] = subscription.shirt_size
        @merge_vars[:COUNTRY]    = subscription.plan.country
        @merge_vars[:PERIOD]     = subscription.plan_period #Sub term length
        @merge_vars[:SUB_STATUS] = subscription.subscription_status

        response = lists.update_member data
      rescue Gibbon::MailChimpError => e
        if unsubscribed_from_list_message?(e.message) || no_record_of_email_message?(e.message)
          {}
        else
          raise e
        end
      rescue => e
        Rails.logger.error "Unable to update #{@email}. Reason: #{e}"
      end

      response
    end

    private
    def lists
      Gibbon::API.lists
    end

    def data
      {
        id: ENV['MAILCHIMP_LIST_ID'],
        email: { email: @email },
        merge_vars: @merge_vars,
        double_optin: @double_optin,
        update_existing: @update_existing
      }
    end

    def get_friendbuy_PURL
      fb = Friendbuy::API.new(customer_id: @user.email, campaign_id: ENV['FRIENDBUY_PURL_WIDGET_CAMPAIGN_ID'])

      fb.get_PURL
    end

    def unsubscribed_from_list_message?(message)
      message =~ /does\ not\ belong/
    end

    def no_record_of_email_message?(message)
      message =~ /no\ record\ of\ the\ email\ address/
    end
  end
end
