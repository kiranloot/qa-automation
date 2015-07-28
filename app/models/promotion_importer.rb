require 'activemodel_errors_standard_methods'

# Imports promotions from a CSV.
class PromotionImporter
  include ActiveModelErrorsStandardMethods

  def initialize(csv_file)
    @promotions_csv = csv_file
  end

  def import_promotions
    hashes = convert_csv

    hashes.each do |hash|
      create_promotion(hash)
    end
  end

  def create_promotion(hash)
    promotion = Promotion.new(promotion_attributes(hash))
    (create_promotion_with_associations = CreatePromotionWithRecurlyCoupon.new(
      promotion,
      eligible_plans(eligible_plan_names(hash))
    )).perform
    build_coupons(coupon_codes(hash))

    if create_promotion_with_associations.errors.any?
      Airbrake.notify(create_promotion_with_associations.errors.full_messages.to_sentence, {
                                 component:  'PromotionImporter',
                                 action:     "create_promotion #{ promotion.coupon_prefix }"
                               })
    else
      RecurlyWorkers::CouponWorker.perform_async(promotion.id)
    end
  end

  def convert_csv
    array_of_hashes = []
    CSV.foreach(@promotions_csv.path, headers: true, header_converters: :symbol) do |row|
      array_of_hashes.push row.to_hash
    end

    array_of_hashes
  end

  def promotion_attributes(hash)
    trigger_event     = hash[:trigger_event].sub(/\r/, ' ')
    starts_at         = parse_date(hash[:starts_at])
    ends_at_date      = hash[:ends_at].present? ? hash[:ends_at] : '01-01-2200'
    ends_at           = parse_date(ends_at_date)

    {
      name: hash[:name],
      coupon_prefix: hash[:prefix],
      description: hash[:description],
      starts_at: starts_at,
      ends_at: ends_at,
      one_time_use: hash[:one_time_use],
      adjustment_amount: hash[:adjustment_amount],
      adjustment_type: hash[:adjustment_type].capitalize,
      conversion_limit: hash[:conversion_limit],
      trigger_event: trigger_event.upcase
    }
  end

  def eligible_plans(eligible_plan_names)
    Array.new.tap do |eligible_plans|
      eligible_plan_names.each do |eligible_plan_name|
        eligible_plans << Plan.find_by_name(eligible_plan_name)
      end
    end
  end

  def build_coupons(coupon_codes)
    Array.new.tap do |coupons|
      coupon_codes.each do |coupon_code|
        coupons << Coupon.new(code: coupon_code, usage_count: 0)
      end
    end
  end

  def coupon_codes(hash)
    quantity = hash[:quantity].try(:to_i) || 1
    prefix = hash[:prefix]
    prefix_length = prefix.length
    char_length = hash[:char_length].try(:to_i) || 0
    char_length = prefix_length < char_length ? char_length : prefix_length

    code_generator = CouponCodeGenerator.new(
      prefix: prefix,
      char_length: char_length,
      quantity: quantity
    )
    code_generator.generate
  end

  def eligible_plan_names(hash)
    (hash[:eligible_plans] || '').split(/[\r?\n]/)
  end

  private
    def parse_date(date_string)
      return if date_string.nil?

      array = date_string.split('-')
      array[0], array[1] = array[1], array[0]

      array.join('-')
    end
end
