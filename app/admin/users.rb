ActiveAdmin.register User do
  menu :priority => 3, :if => proc{ !GlobalConstants::BLOCK_ADMIN_USERS }
  actions :all, except: [:destroy]

  index do
    column :id
    column :account_status do |user|
      status = user.account_status
      status_tag(status, (status == "active" ? :ok : :error))
    end
    column :email
    column :full_name do |user|
      link_to user.full_name, admin_user_path(user)
    end

    unless GlobalConstants::BLOCK_ADMIN_USERS
      actions
    end
  end

  form do |f|

    f.inputs 'Edit Details' do
      f.input :email
      f.input :password, required: false
      f.input :password_confirmation
      f.input :full_name
      if f.object.access_locked?
        f.input :locked_at, as: :boolean, label: "This account is locked. Unlock?"
      end
    end

    f.actions
  end

  filter :email, as: :string, filters: ['equals', 'contains', 'starts_with', 'ends_with']
  filter :account_status

  controller do
    def update
      if user_params && (user_params['password'] == nil || user_params['password'].empty?)
        user_params.delete('password')
        user_params.delete('password_confirmation')
      end
      
      resource.unlock_access! if user_params['locked_at'] == '1'
      user_params.delete('locked_at')

      begin
        errors = []

        if user_email_param.present? && user_email_param != resource.email
          errors += update_email
          user_params.delete :email
        end

        resource.assign_attributes user_params
        errors += resource.errors.full_messages unless resource.valid?

        if errors.empty?
          resource.save!
          redirect_to resource_path, success: 'Update successful'
        else
          flash.now[:alert] = errors.to_sentence
          render :edit
        end
      rescue StandardError => e
        env['airbrake.error_id'] = notify_airbrake(e)
        flash.now[:error] = 'Unable to update user.'
        render :edit
      end
    end

    private

    def user_email_param
      user_params[:email]
    end

    def update_email
      email_changer = User::EmailChanger.new(resource, user_email_param)
      email_changer.perform
      email_changer.errors.full_messages
    end

    def user_params
      @user_params = @user_params || permitted_params['user']
    end
  end

  show do
    @zendesk_tickets = user.get_zendesk_tickets
    fb = Friendbuy::API.new(customer_id: user.email, campaign_id: ENV['FRIENDBUY_PURL_WIDGET_CAMPAIGN_ID'])
    @friendbuy_purl = fb.get_PURL

    panel "User Details" do
      attributes_table_for user do
        row("ID") { user.id }
        row("Full Name") { user.full_name }
        row("Email") { user.email }
        row("Status") do
          status_tag(user.account_status, user.account_status == "active" ? :ok : :error)
        end
        row("Sign In Count") { user.sign_in_count }
        row("Failed Attempts") { user.failed_attempts }
        row("reset password token") { user.reset_password_token }
        row("confirmation token") { user.confirmation_token }
        row("unlock token") { user.unlock_token }
        row("created at") { user.created_at }
        if user.campaign_conversion
          row("UTM Campaign") { user.campaign_conversion_utm_campaign }
          row("UTM Medium") { user.campaign_conversion_utm_medium }
          row("UTM Source") { user.campaign_conversion_utm_source }
        end
        row("Friendbuy PURL") { @friendbuy_purl }
      end

    end

    panel "Subscriptions" do
      table_for user.subscriptions do |s|
        s.column("ID") { |sub| sub.id }
        s.column("Status") do |sub|
          status = sub.subscription_status
          status_tag(status, (status == "active" ? :ok : :error))
        end
        s.column("Plan") { |sub| sub.plan.name }
        s.column("Shirt Size") { |sub| sub.readable_shirt_size }
        s.column("Name") { |sub| sub.name }
        s.column("Coupon") { |sub| sub.coupon_code }
        s.column("Recurly Subscription ID") { |sub| sub.recurly_subscription_id }
        s.column("Recurly Account ID") { |sub| sub.recurly_account_id }
        s.column("Created at") do |sub|
          sub.created_at.strftime("%B %d, %Y %H:%M")
        end
        s.column("") do |sub|
          link_to "view", admin_subscription_path(sub)
        end
        s.column("") do |sub|
          unless user.total_store_credits == 0
            link_to "redeem(#{money_format(user.total_store_credits)})", redeem_store_credits_admin_subscription_path(sub), method: :put,
            data: {confirm: "You are about to redeem all of the user's store credits for this subscription. Are you sure?"}
          end
        end
      end
    end

    panel "Store Credits" do
      table_for user.store_credits do |store_credit|
        store_credit.column("ID") { |credit| credit.id }
        store_credit.column("Amount") { |credit| credit.amount }
        store_credit.column("Referrer ID") { |credit| link_to credit.referrer_user_id, admin_user_path(credit.referrer_user_id) }
        store_credit.column("Referrer Email") { |credit| credit.referrer_user_email }
        store_credit.column("Referred User ID") { |credit| link_to credit.referred_user_id, admin_user_path(credit.referred_user_id) }
        store_credit.column("Referred User Email") { |credit| credit.referred_user_email }
        store_credit.column("Status") { |credit| credit.status }
        store_credit.column("Friendbuy Conversion ID") { |credit| credit.friendbuy_conversion_id }
      end
    end

    panel "User Change Logs" do
      table_for user.versions do
        column("") do |v|
          link_to 'view', admin_paper_trail_version_path(v)
        end
        column("Date") {|v| v.created_at}
        column :event
        column("Changed By") {|v| v.whodunnit}
      end
    end

    panel "Zendesk Tickets" do
      table do
        th ""
        th "Status"
        th "Created"
        th "Updated"
        th "Type"
        th "Subject"
        th "Description"
        th "Priority"

        @zendesk_tickets.each do |ticket|
          tr do
            td zendesk_ticket_link(ticket.id)
            td ticket.status
            td ticket.created_at
            td ticket.updated_at
            td ticket.type
            td ticket.subject
            td ticket.description
            td ticket.priority
          end
        end
      end
    end
  end

  permit_params :email, :password, :password_confirmation, :full_name, :locked_at
end
