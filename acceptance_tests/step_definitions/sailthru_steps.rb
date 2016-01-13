#GIVENS
Given /^the user's email (does not exist|exists) in sailthru$/ do |exists|
  if exists == 'does not exist'
    expect($test.sailthru.get_user($test.user.email).keys.include?('error')).to be_truthy
  elsif exists == 'exists'
    expect($test.sailthru.get_user($test.user.email)['vars'].keys.include?('customer_number')).to be_truthy
  end
end

#THENS
Then /^the user's email should be in the (.*) bucket in sailthru$/ do |list|
    expect($test.sailthru.email_in_list?($test.user.email, list)).to be_truthy
end

Then /^the user's email should have an? (.*?)\s?subscription status of (.*) in sailthru$/ do |type, status|
    expect($test.sailthru.email_has_sub_status?($test.user.email, type, status)).to be_truthy
end
