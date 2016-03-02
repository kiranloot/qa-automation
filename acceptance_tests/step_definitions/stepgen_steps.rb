When /the admin user navigates to the admin promotions page/ do
  $test.current_page.click_promotions
  $test.current_page = AdminPromotionsPage.new
end

When /admin creates a new (.*) promotion with a (\d*) (\w*) discount and passes to user/ do |promo_type, adjustment_amount, adjustment_type|
  #assumes you are already logged into the admin page and on the promotions page.
  $test.user.create_user_promotion(promo_type, adjustment_type, adjustment_amount)
  $test.current_page.create_promotion($test.user.promo)
  step "logs out of admin"
  #step "focus on subject user"
end

When /admin creates the new promotion$/ do
  $test.current_page.create_promotion($test.user.promo)
end

#When /focus on subject user/ do
  #$test.set_subject_user
#end
