#Recurly steps
Then(/^recurly should have a matching subscription$/) do
  $recurly.verify_subscription_type
end

Then(/^recurly should now have a (.*) month subscription plan$/) do |months|
  $recurly.verify_subscription_upgrade (months)
end
       
Then(/^recurly should have a (.*) month subscription for the (.*) crate$/) do |months, product|
  $recurly.verify_level_up_subscription(months,product)
end

Then(/^the recurly subscription should be (.*)$/) do |status|
  $recurly.verify_status (status)
end

Then(/^the recurly billing address should be updated$/) do
  $recurly.verify_billing
end