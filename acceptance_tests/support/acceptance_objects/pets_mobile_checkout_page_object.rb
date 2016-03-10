require_relative "mobile_checkout_page_object"

class PetsMobileCheckoutPage < MobileCheckoutPage
  def initialize
    super
    @page_type = "pets_checkout"
    setup
  end

  def select_shirt_size(size)
    #stub
  end

  def select_pet_shirt_size(size)
    select "#{size}", :from => "option_type_shirt"
  end

  def select_pet_collar_size(size)
    select "#{size}", :from => "option_type_collar"
  end
end
