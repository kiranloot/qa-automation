require 'active_support/concern'

module ActiveModelErrorsStandardMethods
  extend ActiveModel::Naming      # Required dependency for ActiveModel::Errors
  extend ActiveSupport::Concern

  attr_writer :errors

  def read_attribute_for_validation(attr)
    send(attr)
  end

  def errors
    @errors = @errors || ActiveModel::Errors.new(self)
  end

  def merge_errors(external_errors)
    external_errors.each { |attribute_key, error_message| errors.add attribute_key, error_message }
  end

  def merge_recurly_errors(recurly_errors)
    recurly_errors.each do |attribute_key, error_messages|
      error_messages.each { |error_message| errors.add attribute_key, error_message }
    end
  end

  class_methods do
    def human_attribute_name(attr, options = {})
      attr
    end

    def lookup_ancestors
      [self]
    end
  end
end
