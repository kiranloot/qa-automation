#GIVENS
Given /that I want to test the db and redis objects/ do
  $test.db.registered_one_active
end
#WHENS


#THENS
Then /all coupon codes in the database should be unique/ do
  expect($test.all_coupon_codes_unique?).to be true
end

