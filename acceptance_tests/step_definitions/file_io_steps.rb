#GIVENS
Given /^there is a (.*) file in the tmp dir$/ do |filename|
  yml = YAML.load(File.open("tmp/#{filename}"))
  $test.user.email = yml["email"]
  $test.user.recurly_rebill_date = yml["rebill"]
  $test.user.new_rebill_date = $test.convert_time_to_display_rebill(yml["rebill"])
end

#THENS
Then /^write this subscription's information into a file named (.*) in the tmp dir$/ do |filename|
  yml = File.open("tmp/#{filename}", "w")
  yml.puts ("email: #{$test.user.email}")
  yml.puts ("rebill: #{$test.user.recurly_rebill_date}")
  yml.close
end
