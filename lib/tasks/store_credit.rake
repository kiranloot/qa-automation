namespace :store_credit do

  desc 'validate store credits'
  task :redeem_store_credits => :environment do
    StoreCredit.process_pending_credits
  end

  desc 'sync_conversion_events'
  task sync_conversion_events: :environment do
    store_credit_conversion_ids = StoreCredit.all.map(&:friendbuy_conversion_id)
    store_credit_conversion_ids.reject! { |sc| sc.blank? }
    missing_conversions = FriendbuyConversionEvent.where('conversion_id NOT IN (?)', store_credit_conversion_ids)
    missing_conversions = missing_conversions.where('created_at >= ?', Date.yesterday-5.days)
    count = 0
    found = 0
    fixed = 0
    @logger = Logger.new('log/store_credit_missing.log')
    missing_conversions.each do |missing|
      if StoreCredit.where(friendbuy_conversion_id: missing.conversion_id).blank?
        count += 1

        if missing.possible_self_referral.downcase == 'true'
          status = 'possible_self_referral'
        else
          status = 'pending'
        end
        @logger.info "Store Credit Missing for conversion: #{missing.conversion_id}"
        begin
          StoreCredit.create!(referrer_user_id: missing.share_customer_id,
            referrer_user_email: missing.email,
            referred_user_id: missing.new_order_customer_id,
            referred_user_email: missing.email,
            status: status,
            friendbuy_conversion_id: missing.conversion_id,
           amount: 7.00
          )
          fixed += 1
        rescue => e
          @logger.error "Error: #{e.message}"
        end
      else
        found += 1
      end
    end
    puts 'Counts:'
    puts "new: #{count}"
    puts "already in db: #{found}"
    puts "fixed: #{fixed}"
  end
end
