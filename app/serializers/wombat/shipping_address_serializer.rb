require 'active_model/serializer'

module Wombat
  class ShippingAddressSerializer < ActiveModel::Serializer
    attributes :firstname, :lastname, :address1, :address2, :zipcode, :city,
               :state, :country, :phone

    def firstname
      object.first_name
    end

    def lastname
      object.last_name
    end

    def address1
      object.line_1
    end

    def address2
      object.line_2 || ""
    end

    def zipcode
      object.zip
    end

    def phone
      "1231231234"
    end
  end
end
