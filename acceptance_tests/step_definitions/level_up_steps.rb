When /the user selects a level up (.*) month subscription for the (.*) (crate|bundle)/ do |months, product, item|
  bundle = item == 'crate' ? false : true
  $test.current_page.choose_bundle(product, bundle)
  $test.current_page.choose_duration(months)
  $test.current_page.choose_sizes($test.user.subscription)
  $test.current_page.continue_to_checkout
end

When /selects the (.*) level up (crate|bundle)/ do |crate, item|
  bundle = item == 'crate' ? false : true
  $test.current_page.choose_bundle(crate, bundle)
end

When /selects the (.*) month duration/ do |months|
  $test.current_page.choose_duration(months)
end

When /sets the sizes to (.*), shirt (.*), and waist (.*)$/ do |gender, shirt_size, waist_size|
  $test.user.subscription.set_gender_and_sizes(gender, shirt_size, waist_size)
  $test.current_page.choose_sizes($test.user.subscription)
end

When /continues to checkout$/ do
  $test.current_page.continue_to_checkout
end

Then /the new level up subscription should be added to the user account/ do
  step "the user visits the my account page"
  $test.current_page.verify_levelup_subscription_added
end

Then /^the (mens|womens) (s|m|l|xl|2xl|3xl|4xl|5xl) option for level up tshirt should be soldout/ do |gender, size|
  $test.current_page.lu_variant_sold_out?(gender, size)
end

#Then /the (.*) option for level up (.*) should be soldout/ do |variant, product|
#  $test.current_page.level_up_variant_soldout?(variant, product)
#end

Then /the (.*) crate should be sold out/ do |product|
  $test.current_page.sold_out?
end
