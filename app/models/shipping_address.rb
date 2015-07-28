# == Schema Information
#
# Table name: addresses
#
#  id              :integer          not null, primary key
#  line_1          :string(255)
#  line_2          :string(255)
#  state           :string(255)
#  city            :string(255)
#  zip             :string(255)
#  type            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  first_name      :string(255)
#  last_name       :string(255)
#  country         :string(255)
#  subscription_id :integer
#

class ShippingAddress < Address
  # virtual attributes
  attr_accessor :full_name
  has_many :subscriptions

  validates :country, inclusion: { in: GlobalConstants::SHIPPING_COUNTRIES_CODE }

  after_update :notify_subscriptions_of_address_change

  has_paper_trail

  def sync_to_chargify(customer, live=false)
    customer.address   = line_1
    customer.address_2 = line_2
    customer.city      = city
    customer.state     = state
    customer.zip       = zip
    customer.country   = country

    customer.save if live
  end

  def sync_from_chargify(customer, live=false)
    self.line_1  = customer.address
    self.line_2  = customer.address_2
    self.city    = customer.city
    self.state   = customer.state
    self.zip     = customer.zip
    self.country = customer.country

    self.save if live
  end

  def self.sync_or_create_shipping_address_from_chargify(shipping_address)
    shipping_hash = {
      first_name: shipping_address[:first_name],
      last_name:  shipping_address[:last_name],
      line_1:     shipping_address[:address],
      line_2:     shipping_address[:address_2],
      city:       shipping_address[:city],
      state:      shipping_address[:state],
      zip:        shipping_address[:zip],
      country:    shipping_address[:country]
    }
    if (s_addr = self.where(shipping_hash).try(:first)).blank?
      sa_hash = { shipping_address_attributes: shipping_hash }
    else
      sa_hash = { shipping_address_id: s_addr.id }
    end
    sa_hash
  end

  private

    def notify_subscriptions_of_address_change
      subscriptions.map(&:handle_shipping_address_changed)
    end
end
