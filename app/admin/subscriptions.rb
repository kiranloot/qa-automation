ActiveAdmin.register Subscription do
  actions :all, except: [:new, :create, :destroy]
  collection_action :autocomplete_user_email, :method => :get
  menu :priority => 4, :if => proc{ !GlobalConstants::BLOCK_ADMIN_USERS }
  actions :all, except: [:new, :create, :destroy]

  SHIRT_SIZES = ['M S', 'M M', 'M L', 'M XL', 'M XXL', 'M XXXL', 'W S', 'W M', 'W L', 'W XL', 'W XXL', 'W XXXL']

  scope :all, default: true
  scope :active
  scope('Inactive') { |sub| sub.where.not(subscription_status: 'active') }
  scope('Hold') { |sub| sub.joins(:shipping_address).where.not(addresses: { flagged_invalid_at: nil }) }
  scope :domestic
  scope :international

  index do
    render 'tealium_utag'
    render 'tealium_udo'
    column :status do |sub|
      status_tag(*adjusted_current_status(sub))
    end
    column :plan do |sub|
      sub.plan.readable_name
    end

    column :user_email do |sub|
      link_to sub.user.email, admin_user_path(sub.user)
    end

    column "Shipping Name" do |sub|
      "#{sub.shipping_address.first_name} #{sub.shipping_address.last_name}"
    end
    column :shirt_size
    column :name
    column :next_assessment_at
    column 'Month Skipped' do |sub|
      "#{sub.month_skipped}"
    end

    unless GlobalConstants::BLOCK_ADMIN_USERS
      # TODO: Clean this up.
      actions defaults: false do |sub|
        link_to 'show', admin_subscription_path(sub)
      end

      actions defaults: false do |sub|
        link_to 'edit', edit_admin_subscription_path(sub)
      end

      column do |sub|
        if %w(active past_due).include?(sub.subscription_status) && sub.cancel_at_end_of_period.nil?
          render partial: 'cancellation', locals: {subscription: sub}
        elsif sub.cancel_at_end_of_period
          link_to('Reactivate', reactivate_admin_subscription_path(sub), method: 'put')
        else
          link_to('Reactivate', show_reactivate_admin_subscription_path(sub))
        end
      end
    end
  end

  filter :user_email, as: :string, filters: ['equals', 'contains', 'starts_with', 'ends_with']
  filter :subscription_status
  filter :plan
  filter :shirt_size, as: :select, collection: SHIRT_SIZES
  filter :coupon_code
  filter :id

  csv do
    column :name do |sub|
      sub.user.full_name
    end
    column :email do |sub|
      sub.user.email
    end
    column :shipping_1 do |sub|
      sub.shipping_address.line_1
    end
    column :shipping_2 do |sub|
      sub.shipping_address.line_2
    end
    column :city do |sub|
      sub.shipping_address.city
    end
    column :state do |sub|
      sub.shipping_address.state
    end
    column :zip do |sub|
      sub.shipping_address.zip
    end
    column :country do |sub|
      sub.shipping_address.country
    end
    column :valid_address do |sub|
      sub.address_flagged? ? 'NO' : 'YES'
    end
    column :item do |sub|
      sub.shirt_size
    end
    column :order do |sub|
      sub.id
    end
  end

  #  == Controller Actions ==
  controller do
    autocomplete :user, :email

    def tealium_tracking_udo
      @tealium_udo = @tealium_udo || Tealium::UniversalData.new(
        page_type: "admin_subscriptions",
        user: current_user
      )
    end

    def scoped_collection
      super.includes :shipping_address, :billing_address, :user, :plan
    end

    def adjusted_current_status(sub)
      status = sub.current_status
      status += ' / HOLD' if sub.address_flagged?

      type = case status
        when 'CANCELED EOP'
          :warning
        when 'active'
          :ok
        else
          :error
        end

      return status, type
    end
    helper_method :adjusted_current_status

    def update(options={}, &block)
      @subscription = Subscription.find(params[:id])
      errors = []

      begin
        Subscription.transaction do
          if subscription_params_user_id != @subscription.user_id
            subscription_user_changer = Subscription::UserChanger.new(@subscription, new_user)
            subscription_user_changer.perform
          end

          update_next_assessment

          @subscription.update_attributes permitted_params[:subscription]
        end
        errors += @subscription.errors.full_messages
      rescue StandardError => e
        errors << e.message
      end

      if errors.empty?
        flash[:success] = 'Successfully updated subscription.'
      else
        flash[:error] = errors.to_sentence
      end

      redirect_to :back
    end

    def next_assessment_date
      next_assessment_str = params[:subscription][:next_assessment_at]
      Time.local(*next_assessment_str.split('-'))
    end

    def update_next_assessment
      unless params[:subscription][:next_assessment_at].blank?
        next_assessment = next_assessment_date

        if next_assessment.to_date != @subscription.next_assessment_at.to_date
          @subscription.readjust_rebilling_date(next_assessment)
        end
      end
    end

    def undo_cancel(subscription)
      canceller = Subscription::Canceller.new(subscription)
      canceller.remove_cancel_at_end_of_period

      if resource.cancel_at_end_of_period
        flash[:error] = 'Failed to remove cancellation at end of period.'
      else
        flash[:success] = 'Successfully removed cancellation at end of period.'
      end
    end

    def reactivate_subscription(subscription, next_bill_date=nil)
      reactivator = Subscription::Reactivator.new(subscription, {next_bill_date: next_bill_date})
      reactivator.reactivate

      if reactivator.errors.any?
        flash[:error] = reactivator.errors.full_messages.to_sentence
      else
        flash[:notice] = 'Subscription successfully reactivated.'
      end
    end

    def new_user
      unless defined?(@new_user)
        @new_user = User.find(subscription_params_user_id)
      end
      @new_user
    end

    def subscription_params_user_id
      subscription_params[:user_id].to_i
    end

    def subscription_params
      params[:subscription]
    end
  end

  show do
    recurly_subscription_data = RecurlyAdapter::SubscriptionDataRetriever.new(subscription.recurly_subscription_id)
    @recurly_subscription     = recurly_subscription_data.subscription
    @recurly_account          = recurly_subscription_data.account
    @transactions             = recurly_subscription_data.transactions
    @invoices                 = recurly_subscription_data.invoices
    @subscription_units       = subscription.latest_period.subscription_units

    panel "Subscription Details" do
      attributes_table_for subscription do
        row("ID") { subscription.id }
        row("subscription status") do
          status_tag(*adjusted_current_status(subscription))
        end

        if subscription.address_flagged?
          flag = subscription.shipping_address.flagged_invalid_at
          row("Hold details") do
            "Shipping address flagged as invalid #{(Date.today - flag.to_date).to_i} days ago (#{flag.strftime('%c')})"
          end
        end
        row("Month Skipped") do
          "#{subscription.month_skipped}"
        end
        row("user") do
          link_to subscription.user_email, admin_user_path(subscription.user)
        end
        row("Shirt Size") { subscription.readable_shirt_size }
        row("Plan") do
          subscription.plan.readable_name
        end
        row("Cost") { subscription.cost }
        row("Coupon Code") { subscription.coupon_code }
        row("Billing Address") do |sub|
          ba = subscription.billing_address
          addr  = "#{ba.line_1} #{ba.line_2}<br/>"
          addr += "#{ba.city}, #{ba.state}, #{ba.zip}, #{ba.country}"
          link_to addr.html_safe, admin_address_path(ba)
        end
        row("Shipping Address") do |sub|
          sa = subscription.shipping_address
          addr  = "#{sa.line_1} #{sa.line_2}<br/>"
          addr += "#{sa.city}, #{sa.state}, #{sa.zip}, #{sa.country}"
          link_to addr.html_safe, admin_address_path(sa)
        end
        row("Last 4") { subscription.last_4 }
        row("updated at") { subscription.updated_at }
        row("created at") { subscription.created_at }
        row("recurly subscription id") do
          link_to subscription.recurly_subscription_id, recurly_subscription_link(subscription.recurly_subscription_id), target: '_blank'
        end
        row("recurly account id") do
          link_to subscription.recurly_account_id, recurly_account_link(subscription.recurly_account_id), target: '_blank'
        end
      end
    end

    unless @subscription_units.blank?
      panel "Tracking Units" do
        @subscription_units.each do |subscription_unit|
          attributes_table_for subscription_unit do
            row ("month_year") { subscription_unit.month_year }
            row ("tracking_number") { subscription_unit.tracking_number }
            row ("carrier_code") { subscription_unit.carrier_code }
            row ("service_code") { subscription_unit.service_code }
            row ("tracking_url") { subscription_unit.tracking_url }
          end
        end
      end
    end

    panel "Recurly Subscription's Details" do
      attributes_table_for @recurly_subscription do
        row ("ID") do
          link_to @recurly_subscription.uuid, recurly_subscription_link(@recurly_subscription.uuid), target: '_blank'
        end
        row ("Sign Up Date") { @recurly_subscription.activated_at }
        row ("Status") do
          status_tag(@recurly_subscription.state, @recurly_subscription.state == 'active' ? :ok : :error)
        end
        row ("Current period ends at") { @recurly_subscription.current_period_ends_at.try(:in_time_zone, "Pacific Time (US & Canada)") }
      end
    end

    panel "Recurly Account details" do
      attributes_table_for @recurly_account do
        row :state
        row :email
        row :created_at
        row ("Full Name") do |account|
          "#{account.first_name} #{account.last_name}"
        end
        row("Address") do |account|
          sanitize(
            "#{account.address.address1} #{account.address.address2} <br/>
            #{account.address.city}, #{account.address.state}, #{account.address.zip} <br/>
            #{account.address.country}"
          )
        end
      end
    end

    panel "Recurly's Credit Card Details" do
      attributes_table_for @recurly_account.billing_info do
        row("Full Name") do |credit_card|
          "#{credit_card.first_name} #{credit_card.last_name}"
        end
        row("Address") do |credit_card|
          sanitize(
            "#{credit_card.address1} #{credit_card.address2} <br/>
            #{credit_card.city}, #{credit_card.state}, #{credit_card.zip} <br/>
            #{credit_card.country}"
          )
        end
        row :card_type
        row :last_four
      end
    end

    panel "Transactions Details" do
      table_for @transactions do
        column('ID') do |t|
          link_to t.uuid, recurly_transaction_link(t.uuid), target: '_blank'
        end
        column :action
        column :created_at
        column :currency
        column ("Amount") { |t| cents_to_dollars(t.amount_in_cents) }
        column("Status") do |t|
          status_tag(t.status.to_s, t.status == 'success' ? :ok : :error)
        end
      end
    end

    panel "Invoices Details" do
      table_for @invoices do
        column('ID') do |invoice|
          link_to invoice.invoice_number, recurly_invoice_link(invoice.invoice_number), target: '_blank'
        end
        column :state
        column :created_at
        column :closed_at
        column :currency
        column ('Subtotal') { |t| cents_to_dollars(t.subtotal_in_cents) }
        column ('Tax') { |t| cents_to_dollars(t.tax_in_cents) }
        column ('Total') { |t| cents_to_dollars(t.total_in_cents) }
      end
    end

    panel "Subscription Change Logs" do
      table_for subscription.versions do
        column("") do |v|
          link_to 'view', admin_paper_trail_version_path(v)
        end
        column("Date") {|v| v.created_at}
        column :event
        column("Changed By") {|v| v.whodunnit}
      end
    end
  end

  # PUT #redeem_store_credits
  # Update Gateway Subscription to have certain amount of credits
  member_action :redeem_store_credits, method: :put do
    @subscription = Subscription.find(params[:id])

    if @subscription.redeem_store_credits
      flash[:success] = 'Successfully redeem store credits.'
    else
      flash[:error] = 'Failed to redeem store credits, please try again.'
    end

    if errors = @subscription.errors.presence
      flash[:error] = errors.to_sentence
    else
      flash[:success] = 'Successfully redeemed store credits.'
    end

    redirect_to :back
  end

  member_action :cancel_immediately, method: :put do
    canceller = Subscription::Canceller.new(resource)

    canceller.cancel_immediately

    if errors = canceller.errors.presence
      flash[:error] = errors[:cancel_immediately].to_sentence
    else
      flash[:success] = 'Successfully cancelled subscription.'
    end

    redirect_to :back
  end

  member_action :cancel_at_end_of_period, method: :put do
    @subscription = Subscription.find(params[:id])

    canceller = Subscription::Canceller.new(@subscription)
    canceller.cancel_at_end_of_period

    if @subscription.cancel_at_end_of_period
      flash[:success] = 'Successfully set subscription to cancel at end of term.'
    else
      flash[:error] = 'Failed to set subscription to cancel at end of period.'
    end

    redirect_to :back
  end

  member_action :show_reactivate, method: :get do
    render 'admin/subscriptions/reactivate'
  end

  member_action :reactivate, method: :put do
    if resource.cancel_at_end_of_period
      undo_cancel(resource)
    else
      next_bill_date = if params[:immediate] == "yes"
                         nil
                       else
                         params[:next_billing_date]
                       end
      reactivate_subscription(resource, next_bill_date)
    end

    redirect_to admin_subscription_path(resource)
  end

  member_action :flag, method: :put do
    if resource.shipping_address.update_attributes(flagged_invalid_at: DateTime.now, paper_trail_event: 'Flagged invalid address')
      flash[:notice] = 'Subscription Invalid Address flag set'
      redirect_to resource_path
    else
      flash.now[:error] = 'Error. Subscription flag not set'
      render :edit
    end
  end

  member_action :unflag, method: :put do
    if resource.shipping_address.update_attributes(flagged_invalid_at: nil, paper_trail_event: 'Invalid address flag removed')
      flash[:notice] = 'Subscription Invalid Address flag unset'
      redirect_to resource_path
    else
      flash.now[:error] = 'Error. Flag unset failed'
      render :edit
    end
  end

  collection_action :fix_missing_subscriptions, method: :post do
    fixer = FixMissingSubscriptions.new

    fixer.fix(params[:file])

    if fixer.errors.presence
      flash[:error] = "Failed to fix: #{fixer.errors}"
    else
      flash[:notice] = "Successfully fixed subscriptions"
    end

    redirect_to :back
  end

  #  == END Controller Actions ==

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :user, :as => :autocomplete, :url => autocomplete_user_email_admin_subscriptions_path,
        :input_html => { :id => 'user_email', :name => '', :id_element => '#subscription_user_id',
        :value => (subscription.user_email if subscription.user) }
      f.input :user_id, :as => :hidden, :input_html => { :name => 'subscription[user_id]' }
      f.input :shirt_size, as: :select, collection: SHIRT_SIZES
      f.input :next_assessment_at, as: :datepicker, datepicker_options: {
                min_date: 1.day.from_now.to_date
              }
      f.actions

      render partial: 'flag_invalid_address', locals: {subscription: f.object}
    end
  end

  permit_params :user_id, :shirt_size, :name, :next_assessment_at
end
