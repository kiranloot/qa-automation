require_relative "anime_checkout_page_object"

class AnimeMobileCheckoutPage < AnimeCheckoutPage

  def initialze
    super
    @page_type = "anime_checkout"
    setup
  end

  def select_shirt_size(size)
    find("#option_type_shirt").click
    wait_for_ajax
    find(".select2-results__option", :text => size).click
  end
end
