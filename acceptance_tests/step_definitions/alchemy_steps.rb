#WHENS
When(/^the alchemy user logs into alchemy$/) do
  $test.current_page.login_to_alchemy($test.cms_user.email, $test.cms_user.password)
end

When(/^the user edits the (.*) page$/) do |page|
  $test.current_page.navigate_to('Pages')
  $test.current_page.open_alchemy_page(page)
end

When(/^changes the (.*) text to a random string$/) do |essence|
  @alchemy_rand_string = ('a'..'z').to_a.shuffle[0,8].join
  $test.current_page.edit_text_essence(essence, @alchemy_rand_string)
end

When(/^the user saves the alchemy page$/) do
  $test.current_page.click_save
  $test.current_page.wait_for_preview_to_update(@alchemy_rand_string)
end

When(/^the user publishes the alchemy page$/) do
  $test.current_page.click_publish
end

#THENS
Then(/^the user should see the new alchemy content on the page$/) do
  assert_text(@alchemy_rand_string)
end

Then (/^the user should not see any errors in the alchemy preview pane$/) do
  $test.current_page.preview_pane_no_errors?
end
