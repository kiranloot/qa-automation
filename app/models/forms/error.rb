# Generic error template for Forms:: classes that combine multiple local
# objects with chargify objects for syncing and validation.
#
module Forms
  class Error
    include ActiveModel::Validations

    attr_accessor :objects, :failure_message

    def initialize(*objects)
      @objects = objects
      @failure_message = 'prevented your form from being accepted.'
    end

    def summary
      errors_count = TextHelper.pluralize(count_errors, 'Error')
      html = "#{errors_count} #{failure_message}"

      if base_error_messages.present?
        messages = base_error_messages.map { |msg| "<li>#{msg}</li>" }.join
        html << "<br/><br/><ul>#{messages}</ul>"
      end

      html.html_safe
    end

    private

      def count_errors
        keys = objects.compact.collect { |object| object.errors.messages.keys }.flatten

        if keys.include?(:base)
          keys.count + base_error_messages.count - 1
        else
          keys.count
        end
      end

      def base_error_messages
        objects.compact.map { |o| o.errors.messages[:base] }.flatten.compact
      end
  end
end
