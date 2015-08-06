#Recurly steps
Then(/^recurly should have a matching subscription$/) do
  $recurly.verify_subscription_type
end

Then(/^recurly should have no subscriptions$/) do
  $recurly.verify_no_subscriptions
end

Then(/^recurly should now have a (.*) month subscription plan$/) do |months|
  $recurly.verify_subscription_plan (months)
end
       
Then(/^recurly should have a (.*) month subscription for the (.*) crate$/) do |months, product|
  $recurly.verify_level_up_subscription(months,product)
end

Then(/^the recurly subscription should be expired$/) do
  $recurly.verify_expired
end
