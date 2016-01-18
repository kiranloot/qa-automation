When /the admin user navigates to the admin promotions page/ do
  $test.current_page.click_promotions
  $test.current_page = AdminPromotionsPage.new
end

When /admin creates a new (.*) promotion with a (\d*) (\w*) discount and passes to user/ do |promo_type, adjustment_type, adjustment_amount|
  #assumes you are already logged into the admin page and on the promotions page.
  $test.current_page.create_promotion(promo_type, adjustment_type, adjustment_amount)
  step "logs out of admin"
  #step "focus on subject user"
end

#When /focus on subject user/ do
  #$test.set_subject_user
#end
