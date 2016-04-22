require_relative "checkout_page_object"

class OnePageCheckout < CheckoutPage
include Capybara::DSL

  def initialize
    super
    @page_type = "core_opc"
    $test.user.crate_type = "Loot Crate"
    setup
  end

  def enter_register_info(user)
    fill_in("user_email", :with => user.email)
    fill_in("user_password", :with => user.password)
  end

  def select_plan(plan)
    create_user_subscription(plan)
    page_scroll(0)
    if plan == 'random'
      rand_key = sub_plans.keys.sample
      target = sub_plans[rand_key]
      plan = rand_key
    else
      target = sub_plans[plan]
    end
    find(:css, "##{target}").click
    wait_for_ajax
    update_target_plan(plan)
  end

  def create_user_subscription(plan)
    $test.user.subscription = Subscription.new(plan, $test.user.crate_type)
  end

  def click_legal_checkbox
    find('label[for=terms-agree-checkbox]').click
  end

  def update_target_plan(plan)
    $test.user.subscription_name = plan_display_names[plan]
  end

  ####
  # Method overrides below don't appear to be used, but were implemented at one point.
  # Leaving commented here in case they wind up being used after all.
  ####


  # def enter_name_on_card(name)
  #   full_name = name.split(' ')
  #   fill_in("checkout_billing_address_first_name", :with => full_name[0])
  #   fill_in("checkout_billing_address_last_name", :with => full_name[1])
  # end

  # def enter_credit_card_number(number)
  #   within_frame(find("#checkout_credit_card_number iframe")){
  #     fill_in("recurly-hosted-field-input", :with => number)
  #   }
  # end

  private
  def plan_display_names
    {
      'one' => '1 Month Plan Subscription',
      'three' => '3 Month Plan Subscription',
      'six' => '6 Month Plan Subscription',
      'twelve' => '12 Month Plan Subscription'
    }
  end
end
