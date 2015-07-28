class FixMissingSubscriptions
  attr_accessor :errors

  def initialize
    @errors = []
  end

  def fix(csv_file)
    sub_ids = chargify_sub_ids_array(csv_file)

    braintree_sub_ids = sub_ids[0]
    nonbraintree_sub_ids = sub_ids[1]

    # Create subscriptions for braintree subs
    braintree_sub_ids.each do |sub_id|
      create_subscription_for(sub_id, true)
    end

    # Create subscritpions for nonbraintree subs
    nonbraintree_sub_ids.each do |sub_id|
      create_subscription_for(sub_id)
    end
  end

  # Returns an array containing [braintree_char_ids_array, nonbraintree_char_ids_array]
  def chargify_sub_ids_array csv_file
    chargify_sub_ids_array = convert_csv(csv_file)

    chargify_sub_ids = chargify_sub_ids_array.map {|h| h[:chargify_subscription_id].to_i}

    nonbraintree_sub_ids = chargify_sub_ids_array.map {|h| h[:nonbraintree_chargify_subscription_id].to_i}

    # Check for existing subscription with chargify sub ids.
    existing_chargify_sub_ids = Subscription.where(chargify_subscription_id: chargify_sub_ids).pluck(:chargify_subscription_id)

    existing_nonbraintree_chargify_sub_ids = Subscription.where(chargify_subscription_id: nonbraintree_sub_ids).pluck(:chargify_subscription_id)

    # Remove chargify sub ids that already exists in the database.
    filtered_sub_ids = chargify_sub_ids - existing_chargify_sub_ids
    filtered_nonbraintree_sub_ids = nonbraintree_sub_ids - existing_nonbraintree_chargify_sub_ids

    # Remove empty spaces
    filtered_sub_ids.delete_if {|e| e == 0}
    filtered_nonbraintree_sub_ids.delete_if {|e| e == 0}


    [filtered_sub_ids, filtered_nonbraintree_sub_ids]
  end

  def create_subscription_for(chargify_sub_id, braintree = nil)
    begin
      # Use proper lootcrate store
      if braintree.nil?
        ChargifySwapper.set_chargify_site_to_authorize
      else
        ChargifySwapper.set_chargify_site_to_braintree
      end

      chargify_sub = ::Chargify::Subscription.find(chargify_sub_id)
      customer     = chargify_sub.customer
      credit_card  = chargify_sub.credit_card
      product      = chargify_sub.product
      user = User.find_by_email customer.email

      if user.present?
        ActiveRecord::Base.transaction do
          # Create chargify customer account for user.
          create_customer_account(user, customer, braintree)
          shipping = create_shipping_address(customer)
          billing  = create_billing_address(credit_card)
          plan     = Plan.where(name: product.handle).first!

          # Create subscription for user.
          sub = user.subscriptions.create!(
            user_id: user.id,
            shirt_size: 'M M',
            name: 'Default Subscription',
            customer_id: customer.id,
            billing_address_id: billing.id,
            shipping_address_id: shipping.id,
            plan_id: plan.id,
            looter_name: "#{customer.first_name} #{customer.last_name}",
            chargify_subscription_id: chargify_sub.id,
            subscription_status: chargify_sub.state,
            braintree: braintree,
            last_4: credit_card_last_four(credit_card),
            next_assessment_at: chargify_sub.next_assessment_at
          )

          create_subscription_period(sub)

          # Set user's account_status to active.
          user.account_status = 'active'
          user.save!

          sub
        end
      else
        raise "Unable to find #{customer.email}"
      end
    rescue => e
      Airbrake.notify(
         error_class:      'Fix Missing Subscriptions Error:',
         error_message:    "Failed to fix chargify subscription #{chargify_sub_id}. Reason: #{e}",
         backtrace:        $ERROR_POSITION,
         environment_name: ENV['RAILS_ENV']
       )

      # Add errors
      @errors.push chargify_sub_id
    end
  end

  def convert_csv(csv_file)
    array_of_hashes = []
    CSV.foreach(csv_file.path, headers: true, header_converters: :symbol) do |row|
      array_of_hashes.push row.to_hash
    end

    array_of_hashes
  end

  private

  def create_customer_account(user, customer, braintree)
    user.chargify_customer_accounts.where(
      chargify_customer_id: customer.id,
      braintree: braintree
      ).first_or_create!
  end

  def create_shipping_address(customer)
    shipping = ShippingAddress.create!(
      line_1: customer.address,
      line_2: customer.address_2,
      state: customer.state,
      city: customer.city,
      zip: customer.zip,
      country: customer.country,
      type: 'ShippingAddress',
      first_name: customer.first_name,
      last_name: customer.last_name
    )

    shipping
  end

  def create_billing_address(credit_card)
    billing = BillingAddress.create!(
      line_1: credit_card.billing_address,
      line_2: credit_card.billing_address_2,
      state: credit_card.billing_state,
      city: credit_card.billing_city,
      zip: credit_card.billing_zip,
      country: credit_card.billing_country,
      type: 'BillingAddress',
      first_name: credit_card.first_name,
      last_name: credit_card.last_name
    )

    billing
  end

  def create_subscription_period(subscription)
    SubscriptionPeriod::Handler.new(subscription).handle_subscription_created
  end

  def credit_card_last_four(credit_card)
    credit_card.masked_card_number.match(/\d+$/)[0] rescue nil
  end
end
