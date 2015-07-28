@month = 6
@subdomain = "lootcrate"

#@csv_fname = '/Users/jsquires/Downloads/subscriptions-lootcrate2-20150603-10030-1v4u4uj.csv'
@csv_fname = '/Users/jsquires/Downloads/subscriptions-lootcrate-20150603-77499-16nfcws.csv'

require 'logger'
require 'csv'
require 'ostruct'

LOGGER = Logger.new("rebills_#{@month}_#{@subdomain}.txt")

LOGGER.level = Logger::INFO

# update the rebill dates
$: << File.expand_path(File.dirname(__FILE__) + '/lib')

require 'chargify_api_ares'

Chargify.configure do |c|
  c.subdomain = @subdomain
  c.site = "https://#{@subdomain}.chargify.com"
  c.api_key = 'nope'
end

SUBSCRIPTION_COLUMNS = %i(id customer_id customer_reference customer_name customer_email state product_id next_product_id product_name recurring_price recurring_interval recurring_interval_unit coupon created_at created_at_day created_at_month created_at_year current_period_starts_at current_period_ends_at next_assessment_at trial_started_at trial_ended_at activated_at expires_at canceled_at canceled_at_day canceled_at_month canceled_at_year cancellation_message balance_in_cents balance revenue_in_cents revenue credit_card_masked_number credit_card_type credit_card_first_name credit_card_last_name credit_card_expiration_month credit_card_expiration_year credit_card_vault credit_card_vault_token credit_card_customer_vault_token credit_card_billing_address credit_card_billing_address_2 credit_card_billing_city credit_card_billing_state credit_card_billing_zip credit_card_billing_country shipping_address shipping_address_2 shipping_city shipping_state shipping_zip shipping_country customer_organization customer_phone cancel_at_end_of_period delayed_cancel_at product_version_number updated_at referral_code) unless defined? SUBSCRIPTION_COLUMNS

unless defined? ChargifySubscriptionRow
  class ChargifySubscriptionRow < Struct.new(*SUBSCRIPTION_COLUMNS); end
end


# this is when to start the "new rebill times".  Needs to be in the future
the_fifth = DateTime.new(2015,@month,5).beginning_of_day

the_sixth = DateTime.new(2015,@month,6).beginning_of_day
the_nineteenth = DateTime.new(2015,@month,19).end_of_day

# change from UTC to EST
offset = Time.now.dst? ? "-0400" : "-0500"
the_fifth = the_fifth.change(:offset => offset)
the_sixth = the_sixth.change(:offset => offset)
the_nineteenth = the_nineteenth.change(:offset => offset)

def chargify_date(s)
  begin
    DateTime.strptime(s,'%Y-%m-%d %H:%M:%S %z')
    # DateTime.strptime(s,'%m/%d/%Y %H:%M')
  rescue
    puts "bad date: #{s}"
    puts caller
  end
end


@num_changed = 0

def chunks
  success_count = 0

  # Load file

  chunks = []
  chunks << []


  counter1 = 0
  counter2 = 0

  CSV.open(@csv_fname, "r" ) do |csv|
    csv.shift
    csv.each do |raw_row|
      chunks[counter1] << raw_row
      counter2 = counter2 + 1
      #          if counter2 == 12
      if counter2 == 12
        counter1 = counter1 + 1
        chunks[counter1] = []
        counter2 = 0
      end

      if counter2 % 8 == 0
        puts "*"
      end
    end # each chargify subscription row
  end # end open


  chunks
end

num_seconds = 0
chunks.each do |chunk|
  threads = []

  chunk.size.times do |num|
    threads << Thread.new {
      chargify_row = ChargifySubscriptionRow.new(*chunk[num])

      LOGGER.info "#{@num_changed} records changed so far"

      if chargify_row.product_name.start_with? 'amiibo'
        puts "skipping #{chargify_row.product_name}"
      end

      if chargify_row.state == "active" && (!chargify_row.product_name.start_with?('amiibo'))
        begin
          if chargify_date(chargify_row.next_assessment_at) >= the_sixth && chargify_date(chargify_row.next_assessment_at) <= the_nineteenth
            subscription =  Chargify::Subscription.find(chargify_row.id)

            # this subscription met our criteria in the csv dump...but let's make sure our info is still accurate!
            if !(subscription.state == "active" && subscription.next_assessment_at >= the_sixth && subscription.next_assessment_at <= the_nineteenth)
              s = "skipping #{chargify_row.id} due to update after csv dump - #{subscription.next_assessment_at}"
              puts s
              LOGGER.info s
            else
              @num_changed = @num_changed + 1
              subscription.next_billing_at = (the_fifth + num_seconds.seconds)
              num_seconds = num_seconds + 2
              LOGGER.info "changing #{chargify_row.id} due to #{chargify_row.next_assessment_at} to #{subscription.next_billing_at}"
              subscription.save
            end
          end
        rescue => e
          LOGGER.info "problem: #{e.message}} - #{chargify_row.id}"
        end
      end
    }
  end
  threads.map(&:join)
end

LOGGER.info "#{@num_changed} records changed"
