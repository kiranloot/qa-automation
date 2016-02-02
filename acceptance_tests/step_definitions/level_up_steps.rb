When /the user selects a level up (.*) month subscription for the (.*) crate/ do |months, product|
  $test.current_page.select_plan(product,months)
end

Then /the new level up subscription should be added to the user account/ do
  step "the user visits the my account page"
  $test.current_page.verify_levelup_subscription_added
end

Then /the (.*) option for level up (.*) should be soldout/ do |variant, product|
  $test.current_page.level_up_variant_soldout?(variant, product)
end

Then /the (.*) crate should be sold out/ do |product|
  $test.current_page.sold_out?(product)
end

