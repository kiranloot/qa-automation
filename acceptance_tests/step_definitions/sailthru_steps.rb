#THENS
Then /^the user's email should be in the (.*) bucket in sailthru$/ do |list|
    expect($test.sailthru.email_in_list?($test.user.email, list)).to be_truthy
end

Then /^the user's email should have a subscription status of (.*) in sailthru$/ do |status|
    expect($test.sailthru.email_has_sub_status?($test.user.email, status)).to be_truthy
end
