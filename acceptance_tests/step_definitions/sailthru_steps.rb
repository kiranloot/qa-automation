#THENS
Then /^the user's email should be in the (.*) bucket in sailthru$/ do |list|
    expect($test.sailthru.email_in_list?($test.user.email, list)).to be_truthy
end
