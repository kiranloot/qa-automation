class CreditCard
  include ActiveModel::Validations

  attr_accessor :number, :cvv, :expiration, :exp_year, :exp_month

  validates_presence_of :number
  validates_presence_of :cvv
  validates_presence_of :expiration
  validate :not_expired?, if: 'expiration.present?'

  def initialize(params = nil)
    return nil if params.blank?
    if params.keys.include?('expiration(1i)')
      CreditCard.sanitize_expiration(params)
    end
    @number     = params[:number]
    @cvv        = params[:cvv]
    @expiration = params[:expiration]
    if expiration.present?
      @exp_year   = expiration.year
      @exp_month  = expiration.month
    end
  end

  def self.sanitize_expiration(cc_params)
    # expiration(3i) is set as negative to get the last day of the month.
    cc_params[:expiration] = Date.new(cc_params['expiration(1i)'].to_i,
                                      cc_params['expiration(2i)'].to_i,
                                      -(cc_params['expiration(3i)'].to_i))
    cc_params.delete('expiration(1i)')
    cc_params.delete('expiration(2i)')
    cc_params.delete('expiration(3i)')
  end

  def not_expired?
    errors.add('expiration', 'Credit card cannot be expired.') if @expiration < Date.today
  end
end
