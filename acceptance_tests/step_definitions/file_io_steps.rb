#GIVENS
Given /^there is a (.*) file in the tmp dir$/ do
end

#THENS
Then /^write this subscription's information into a file named (.*) in the tmp dir$/ do |filename|
  yml = File.open('"tmp/#{filename}"', "w")
  yml.puts ("email: #{$test.user.email}")
  yml.close
end
