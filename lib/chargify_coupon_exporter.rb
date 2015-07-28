require 'csv'

class ChargifyCouponExporter
  CHARGIFY_COUPON_FILE = './lib/lootcrate_coupon_codes_from_chargify.csv' unless defined? CHARGIFY_COUPON_FILE
  CHARGIFY_SUBCODES_FILE = './lib/lootcrate_coupon_subcodes_from_chargify.csv' unless defined? CHARGIFY_SUBCODES_FILE

  def import_coupons_to_database
    array_of_hashes = []

    CSV.foreach(CHARGIFY_COUPON_FILE, headers: true, header_converters: :symbol) do |row|
      array_of_hashes << row.to_hash
    end

    puts "Importing..."

    array_of_hashes.each do |hash|
      ActiveRecord::Base.transaction do
        create_promotion(hash)
      end
    end
  end

  def create_promotion(hash)
    eligible_plans = plans_based_on_product_family_id hash[:family].to_i
    adjustment_amount = hash[:amount_in_cents].blank? ? hash[:percentage] : cents_to_dollar(hash[:amount_in_cents])
    starts_at = hash[:start_date].blank? ? DateTime.now : hash[:start_date]
    ends_at = hash[:end_date].blank? ? DateTime.now + 100.years : hash[:end_date]

    promotion = Promotion.new({
      starts_at: starts_at,
      ends_at:   ends_at,
      description: hash[:description],
      name: hash[:name],
      one_time_use: hash[:conversion_limit].try(:to_i) == 1 ? true : false,
      adjustment_amount: adjustment_amount,
      adjustment_type: hash[:percentage].blank? ? 'Fixed' : 'Percentage',
      conversion_limit: hash[:conversion_limit].try(:to_i),
      trigger_event: "SIGNUP REACTIVATION"
    })

    promotion.eligible_plans << eligible_plans
    promotion.coupons.new(
      code: hash[:code].downcase,
      usage_count: hash[:usage].try(:to_i) || 0,
      status: hash[:archived_at].blank? ? 'Active' : 'Inactive',
      archived_at: hash[:archived_at]
    )

    promotion.save!

    # coupons_array = build_coupons_with_subcodes(hash)

    # unless coupons_array.empty?
    #   promotion.coupons.create(coupons_array)
    # end
  end

  def build_coupons_with_subcodes(hash)
    coupons_array = []

    if hash[:subcodes] == "[]"
      return coupons_array
    else
      codes = hash[:subcodes].gsub(/\"/, '').gsub(/[\]\[]/, "").split(', ')

      codes.each do |code|
        coupons_array << { code: code.downcase, usage_count: 0, status: 'Active' }
      end
    end

    coupons_array
  end

  def plans_based_on_product_family_id(id)
    case id
    when 447628 # Domestic product family.
      plans = domestic_plans
    when 447625 # Canada product family.
      plans = canadian_plans
    when 447626 # International product family.
      plans = international_plans
    end

    plans
  end

  def data_integrity_check
    if Promotion.where(adjustment_type: 'Percentage', adjustment_amount: nil).presence
      puts 'Nil for adjustment_amount for Percentage'
    end

    if Promotion.where(adjustment_type: 'Fixed', adjustment_amount: nil).presence
      puts 'Nil for adjustment_amount for Fixed'
    end

    if Promotion.where(conversion_limit: 1, one_time_use: false).presence
      puts 'one_time_use is wrong.'
    end

    if Coupon.where(status: 'Inactive', archived_at: nil).presence
      puts 'Status is wrong.'
    end
  end

  private

    def cents_to_dollar(cents)
      cents.to_i * 0.01
    end

    def domestic_plans
      @domestic_plans ||= PlanFinder.by_country 'US'
    end

    def canadian_plans
      @canadian_plans ||= PlanFinder.by_country 'CA'
    end

    def international_plans
      exclude_plans = domestic_plans + canadian_plans + amiibo_plans

      @international_plans ||= Plan.where("id NOT IN (?)", exclude_plans.map(&:id))
    end

    def amiibo_plans
      @amiibo_plans ||= Plan.where(name: ['amiibo-crate-three-weekly-payments', 'amiibo-crate-single-payment'])
    end

  class << self
    def import_subcodes_to_database
      array_of_hashes = []

      CSV.foreach(CHARGIFY_SUBCODES_FILE, headers: true, header_converters: :symbol) do |row|
        array_of_hashes << row.to_hash
      end

      puts 'importing...'
      ActiveRecord::Base.transaction do
        array_of_hashes.each do |hash|
          plan_name = hash[:plan_name]
          plan      = Plan.where(name: plan_name).first
          promotion = find_promotion(plan, hash[:code].downcase)

          puts "Importing #{hash[:subcode]}"

          promotion.coupons.create({
            code: hash[:subcode].downcase,
            usage_count: 0,
            status: 'Active',
            archived_at: nil
          })
        end
      end
    end

    def find_promotion(plan, code)
      coupon = Coupon.includes(promotion: :eligible_plans)
        .where(
          plans_promotions: { plan_id: plan.id},
          coupons:          { code: code, status: 'Active' }
         ).first

      coupon.promotion
    end

    def save_subcodes_from_chargify
      hashes = coupon_with_subcode_hashes

      CSV.open( CHARGIFY_SUBCODES_FILE, 'a+' ) do |csv|
        csv << %w(plan_name code subcode)

        hashes.each do |hash|
          chargify_coupon = ::Chargify::Coupon.find_by_product_family_id_and_code(hash[:id], hash[:code])
          api = Local::Chargify::Coupon.new(product_family_id: hash[:id], coupon_id: chargify_coupon.id)

          subcodes = api.get_codes['codes']
          plan_name = family_id_to_plan_name(hash[:id].to_i)

          subcodes.each do |subcode|
            csv << [plan_name, hash[:code], subcode]
          end
        end
      end
    end

    def coupon_with_subcode_hashes
      hashes = [
        { id: 447625, code: '73812132' },
        { id: 447625, code: 'FREECS' },
        { id: 447625, code: 'NYCC1MONTH' },
        { id: 447625, code: 'TUBBEALERTCA' },
        { id: 447625, code: '73812132' },
        { id: 447626, code: 'FREECS' },
        { id: 447626, code: 'NYCC1MONTH' },
        { id: 447626, code: 'TUBEALERTINT' },
        { id: 447628, code: '3S7HM3S8J' },
        { id: 447628, code: 'EXTRALIFE2014' },
        { id: 447628, code: 'FREELOOTCS' },
        { id: 447628, code: 'FREEXQH2' },
        { id: 447628, code: 'GAMESTOP1MONTH' },
        { id: 447628, code: 'GROUPON1MONTH' },
        { id: 447628, code: 'HEARTHCAST1' },
        { id: 447628, code: 'LINKSHARE' },
        { id: 447628, code: 'NYCC1MONTH' },
        { id: 447628, code: 'OPENBLIZZRAID' },
        { id: 447628, code: 'PAXSOUTH6MONTH' },
        { id: 447628, code: 'PAXEASTVOL' },
        { id: 447628, code: 'SPARKCOUPONCODE' },
        { id: 447628, code: 'STACKSOCIAL123142342' },
        { id: 447628, code: 'TUBEALERTUS' },
        { id: 447628, code: 'VIDEOCREW '}
      ]

      hashes
    end

    def family_id_to_plan_name(id)
      case id
      when 447625 #Canadian plan name
        'ca-1-month-subscription'
      when 447626 #I18N plan name
        'au-1-month-subscription'
      when 447628 #Domestic plan name
        '1-month-subscription'
      end
    end

    def save_codes_from_chargify
      families = Chargify::ProductFamily.find :all

      coupons = {}
      families.each do |family|
        family_coupons = []
        page = 1
        while c = Chargify::Coupon.find(:all, :params => { :product_family_id =>  family.id, per_page: 30, page: page })
          break if c.size == 0
          puts c.size
          page = page + 1
          family_coupons << c
        end

        coupons[family.id] = family_coupons
      end

      coupons.keys.each do |key|
        coupons.delete(key) if coupons[key] == []
      end

      coupons.keys.each do |k|
        coupons[k] = coupons[k].flatten
      end

      @logger = Logger.new('promotion_importers')
      @logger.level = Logger::INFO

      CSV.open( CHARGIFY_COUPON_FILE, 'a+' ) do |csv|
        csv << %w(family name code amount_in_cents description percentage conversion_limit start_date end_date archived_at usage subcodes)

        coupons.each_pair do |k,all_coupons_for_family|
          all_coupons_for_family.each do |c|
            puts c.id

            begin
              # Get coupon's usage count.
              api = Local::Chargify::Coupon.new(product_family_id: c.product_family_id, coupon_id: c.id)
              usages = api.get_coupon_usage
              coupon_usage = usages.map { |u| u['signups'] }.sum

              # Get subcodes if single use.
              subcodes = []
              if false #disable for now.
                subcodes = api.get_codes['codes']
              end

              csv << [k, c.name, c.code, c.amount_in_cents, c.description, c.percentage, c.conversion_limit, c.start_date, c.end_date, c.archived_at, coupon_usage, subcodes]
            rescue => e
              @logger.info "Family: #{c.product_family_id}\nCoupon: #{c.id}"
            end
          end
        end
      end
    end
  end
end
