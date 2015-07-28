# encoding: utf-8

class CsvUploader < CarrierWave::Uploader::Base
  attr_accessor :job_id
  storage :fog

  def upload
    Dir.mkdir("#{Rails.root}/tmp/csvs") unless Dir.exist?("#{Rails.root}/tmp/csvs")
    csv_out = "#{Rails.root}/tmp/csvs/subs.csv"

    CSV.open(csv_out, 'w') do |new_csv|
      # write headers
      new_csv << ["name", "email", "looter_name", "shipping_1", "shipping_2",
                  "city", "state", "zip", "country", "address_flagged_at", "item", "product",
                  "chargify_customer_id", "chargify_subscription_id", "order", "chargify_subscription_store",
                  "recurly_subscription_id", "recurly_account_code",
                  "month_skipped"]

      # process and write rows
      Subscription.
        eager_load(:shipping_address, :user, plan: [:product]).
        where(subscription_status: ['active', 'past_due']).
        find_each do |sub|
        begin
          new_csv << [sub.user.full_name, sub.user.email, sub.looter_name,
                      sub.shipping_address.line_1, sub.shipping_address.line_2, sub.shipping_address.city,
                      sub.shipping_address.state, sub.shipping_address.zip, sub.shipping_address.country,
                      sub.shipping_address.flagged_invalid_at, sub.shirt_size, sub.plan.product.name,
                      sub.customer_id, sub.chargify_subscription_id, sub.id, (sub.braintree ? "chargify-braintree" : "chargify-old"),
                      sub.recurly_subscription_id, sub.recurly_account_id,
                      sub.month_skipped]
        rescue => e
          puts e
        end
      end
    end

    self.store!(File.open(csv_out))
    self.job_id = rand 100000
    orders_csv = OrdersCsv.create(job_id: @job_id)
    orders_csv.url = self.url
    orders_csv.status = "current"
    orders_csv.save
  end

  def max_attempts
    1
  end
end
