#THENS
Then(/^the (tracking|confirmation) partial should exist on the page$/) do |type|
  case type
  when 'tracking'
    $test.current_page.tracking_partial_exists?(type)
  when 'comfirmation'
  end
end
