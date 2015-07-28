require 'recurly_validations'

class CouponPrefixFormatValidator < ActiveModel::EachValidator
  include RecurlyValidations

  def validate_each(record, field, code)
    unless code.blank?
      record.errors[field] << 'contains illegal characters' if (code =~ allowed_regex)
    end
  end
end
