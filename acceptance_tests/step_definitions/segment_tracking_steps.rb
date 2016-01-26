#THENS
Then(/^the (tracking|conversion tracking) partial should exist on the page$/) do |type|
  case type
  when 'tracking'
    $test.current_page.tracking_partial_exists?
  when 'conversion tracking'
    $test.current_page.conversion_tracking_partial_exists?
  end
end
