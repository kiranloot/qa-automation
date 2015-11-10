#THENS
Then /^the webhooks fired during (.*) should all have a status of (.*)$/ do |webhook_event, webhook_status|
  expect($test.db.verify_webhooks(webhook_event, webhook_status)).to be_truthy
end

