class Address
  attr_accessor :street, :street_2, :city, :zip, :state

  def initialize(street="", city="", zip="", state="", street_2="")
    @street = street
    @street_2 = street_2
    @city = city
    @zip = zip
    @state = state
  end
end
