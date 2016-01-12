#THENS
Then /^the user's email should be in the (.*) bucket in sailthru$/ do |list|
    expect($test.sailthru.email_in_list?($test.user.email, list)).to be_truthy
end

Then /^the user's email should have an? (.*?)\s?subscription status of (.*) in sailthru$/ do |type, status|
    expect($test.sailthru.email_has_sub_status?($test.user.email, type, status)).to be_truthy
end

Given /^sailthru (.*?)\s?information$/ do |type|
    $test.sailthru.tl
end
