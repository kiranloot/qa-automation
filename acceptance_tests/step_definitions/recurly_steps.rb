#Recurly steps
Then(/^recurly should have a matching subscription$/) do
  recurly = RecurlyAPI.new
  recurly.verify_subscription_type
end

Then(/^recurly should have no subscriptions$/) do
  recurly = RecurlyAPI.new
  recurly.verify_no_subscriptions
end