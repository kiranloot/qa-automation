#Recurly steps
Then(/^recurly should have a matching subscription$/) do
  $test.recurly.verify_subscription_type
end

Then(/^recurly should now have a (.*) month subscription plan$/) do |months|
  $test.recurly.verify_subscription_upgrade (months)
end
       
Then(/^recurly should have a (.*) month subscription for the (.*) crate$/) do |months, product|
  $test.recurly.verify_level_up_subscription(months,product)
end

Then(/^the recurly subscription should be (.*)$/) do |status|
  $test.recurly.verify_status (status)
end

Then(/^the recurly billing address should be updated$/) do
  $test.recurly.verify_billing_address
end

Then(/^the recurly shipping address should be updated$/) do
  $test.recurly.verify_shipping_address
end