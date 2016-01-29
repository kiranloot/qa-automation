#GIVENS
Given /that I want to test the db and redis objects/ do
  $test.db.registered_one_active
end

Given /^the (.*) variant is sold out$/ do |sku|
  $test.db.sellout_variant(sku)
end

Given /^the (.*) product is sold out$/ do |product|
  $test.db.sellout_product(product)
end
#WHENS


#THENS
Then /all coupon codes in the database should be unique/ do
  expect($test.all_coupon_codes_unique?).to be true
end

