#THENS
Then(/^the (.*) partial should exist on the page$/) do |type|
  $test.current_page.partial_exists?(type)
end
