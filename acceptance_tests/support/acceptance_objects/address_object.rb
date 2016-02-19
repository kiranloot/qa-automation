class Address
  attr_accessor :bill_street, :bill_street_2, :bill_city, :bill_zip, :bill_state

  def initialize(street="", city="", zip="", state="", street_2="")
    @bill_street = street
    @bill_street_2 = street_2
    @bill_city = city
    @bill_zip = zip
    @bill_state = state
  end
end
