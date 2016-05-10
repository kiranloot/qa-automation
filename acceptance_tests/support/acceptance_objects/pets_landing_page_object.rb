require_relative "landing_page_object"

class PetsLandingPage < LandingPage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "pets_landing"
    @tracking_script_lines << "lca.page('core_crates', 'show', '');"
    setup
    @plan_display_names = {
      'one' => 'Pets 1 Month Subscription',
      'three' => 'Pets 3 Month Subscription',
      'six' => 'Pets 6 Month Subscription',
      'twelve' => 'Pets 1 Year Subscription'
    }
  end

  def click_get_loot
    find('#alchemy_pets_header_carousel').find_link('GET LOOT PETS').click
    $test.current_page = PetsSubscribePage.new
    wait_for_ajax
  end

    def create_user_subscription(plan)
    super
    $test.user.subscription.sizes[:pet_shirt] = "Dog - #{pet_shirt_sizes.sample}"
    $test.user.subscription.sizes[:pet_collar] = "Dog - #{pet_collar_sizes.sample}"
  end

  def load_checkout_page_object
    if ENV["DRIVER"] == 'appium'
      $test.current_page = PetsMobileCheckoutPage.new
    else
      $test.current_page = PetsCheckoutPage.new
    end
  end

  private
  def pet_shirt_sizes 
    ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL']
  end

  def pet_collar_sizes
    ['S', 'M', 'L']
  end
end
