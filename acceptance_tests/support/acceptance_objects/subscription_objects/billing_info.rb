class BillingInfo
  attr_accessor :cc_number, :last_four, :cvv, :exp_month, :exp_year, :billing_address
  def initialize(cc_number = '4111111111111111')
    set_cc_num(cc_number)
    @cvv = '123'
    @exp_month = "01 - January"
    @exp_year = (Time.now.year+1).to_s
    @billing_address = FactoryGirl.build(:address)
  end

  def set_cc_num(cc_num)
    @cc_number = cc_num
    @last_four = @cc_number.split(//).last(4).join
  end

  def invalidate
    set_cc_num('4567890133334444')
  end
end
