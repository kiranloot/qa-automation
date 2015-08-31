When /the admin user navigates to the admin promotions page/ do
  $test.current_page.click_promotions
  $test.current_page = AdminPromotionsPage.new
end

When /admin creates a new promotion and passes to user/ do
  #assumes you are already logged into the admin page and on the promotions page.
  promo_code = $test.current_page.create_promotion
  step "logs out of admin"
  step "focus on subject user"
  $test.user.coupon_code = promo_code
end

When /focus on subject user/ do
  $test.set_subject_user
end