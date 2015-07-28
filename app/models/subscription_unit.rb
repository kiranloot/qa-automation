class SubscriptionUnit < ActiveRecord::Base
  belongs_to :shipping_address
  belongs_to :subscription_period
  accepts_nested_attributes_for :shipping_address

  # validations
  validates_presence_of :subscription_period_id, :month_year, :shipping_address
  validates :month_year, uniqueness: { scope: [:subscription_period_id] }
  validates :shipstation_order_number, uniqueness: true

  # callbacks
  before_validation :generate_shipstation_order_number, on: :create
  before_update :ensure_not_already_shipped
  after_update :push_to_wombat

  scope :shipped_or_awaiting_shipment, -> { where(status: ['awaiting_shipment', 'shipped'])}

  delegate :subscription, to: :subscription_period

  def shipped?
    tracking_number.present?
  end

  def tracking_url
    Shipping::Tracking.tracking_url(service_code, tracking_number)
  end

  def month
    month_year[0..2]
  end

  def year
    month_year[3..-1]
  end

  def crate_date
    Date.strptime("#{month}/#{year}", '%b/%Y')
  end

  def shipstation_item_name
    s = month.downcase
    mon = s.slice(0, 1).capitalize + s.slice(1..-1)
    shirt_size ? "#{shirt_size} #{mon} #{year} Crate" : "#{mon} #{year} Crate"
  end

  def cancel
    # 'Canceling' really occurs at the subscription level.
    # Our serializer will correctly pick up the subscription's canceled status,
    # that's why we don't need to do anything other than notify shipstation via wombat
    # with an updated state of our subscription shipment
    push_to_wombat
  end

  def handle_subscription_updated
    update_attributes(netsuite_sku: "#{month_year}-#{subscription.shirt_size}", shirt_size: subscription.shirt_size) unless shipped?
  end

  private

    def generate_shipstation_order_number
        dto = OpenStruct.new(month_year: month_year,
                             country: shipping_address.country,
                             state: shipping_address.state,
                             shirt_size: shirt_size,
                             membership_card: Subscription::MembershipCardCalculator.third_subscription_crate_in_lifetime?(subscription),
                             subscription_id: subscription.id)

        number_generator = Subscription::Shipment::ShipstationOrderNumberGenerator.new(dto)
        self.shipstation_order_number = number_generator.generate
    end

    def ensure_not_already_shipped
      !shipped?
    end

    def push_to_wombat
      Wombat::Pusher.push(ActiveModel::ArraySerializer.new(
        [self],
        each_serializer: Wombat::SubscriptionShipmentSerializer,
        root: 'shipment'
      ).to_json)
    end
end
