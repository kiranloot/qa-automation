module Support
  module Recurly
    module Coupon
      def allowed_characters
        [*('a'..'z'), *('0'..'9'), '-', '_', '+']
      end

      def disallowed_characters
        ([*('!'..'~')] - allowed_characters)
      end
    end
  end
end
