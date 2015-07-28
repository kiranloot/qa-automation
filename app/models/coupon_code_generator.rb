require 'activemodel_errors_standard_methods'

# Generates coupon codes according to rules.
class CouponCodeGenerator
  include ActiveModelErrorsStandardMethods

  def initialize(args = {})
    @prefix      = args[:prefix]
    @char_length = args[:char_length]
    @quantity    = args[:quantity]
  end

  attr_reader :errors

  def generate
    codes = []
    generation_attempt = 0

    while generation_attempt < (10 * quantity) && codes.length != quantity do
      code = "#{prefix}#{SecureRandom.hex}".truncate(char_length, omission: '')

      codes << code unless codes.include?(code) || Coupon.new(code: code).invalid?

      generation_attempt += 1
    end

    errors.add(:quantity, "Unable to generate #{quantity} codes with the specified arguments.") unless codes.size == quantity

    codes
  end

  private
    def quantity
      @quantity.to_i
    end

    def char_length
      @char_length.to_i
    end

    def prefix
      @prefix.downcase
    end
end
