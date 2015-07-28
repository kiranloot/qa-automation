class BillingAddress < Address
  # virtual attributes
  attr_accessor :full_name, :credit_card
  has_many :subscriptions

  validates_presence_of :full_name
  validate :full_name_format

  has_paper_trail

  def to_s
    line_1
  end

  def full_name_format
    # Combine and replace first and last name validates presence
    # with full name validation message.
    if self.errors.include?(:first_name) or self.errors.include?(:last_name)
      self.errors.delete(:first_name)
      self.errors.delete(:last_name)
      self.errors.add(:full_name, "Must contain first and last name.")
      false
    else
      true
    end
  end

  def credit_card
    @credit_card
  end

  def credit_card=(options)
    @credit_card ||= CreditCard.new(options)
  end

  def full_name=(value)
    self.first_name, self.last_name = value.to_s.strip.split(' ', 2)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.sync_or_create_billing_address_from_chargify(billing_address)
    billing_hash = {
      first_name: billing_address[:first_name],
      last_name:  billing_address[:last_name],
      line_1:     billing_address[:billing_address],
      line_2:     billing_address[:billing_address_2],
      city:       billing_address[:billing_city],
      state:      billing_address[:billing_state],
      zip:        billing_address[:billing_zip],
      country:    billing_address[:billing_country]
    }
    if (b_addr = self.where(billing_hash).try(:first)).blank?
      ba_hash = { billing_address_attributes: billing_hash }
    else
      ba_hash = { billing_address_id: b_addr.id }
    end
    ba_hash
  end
end
