#WHENS
When(/^the alchemy user logs into alchemy$/) do
  $test.current_page.login_to_alchemy($test.cms_user.email, $test.cms_user.password)
end

When(/^the user edits the (.*) page$/) do |page|
  $test.current_page.navigate_to('Pages')
  $test.current_page.open_alchemy_page(page)
end

When(/^changes the (.*) (basic|rich) text field to a random string( and stores the original)?$/) do |essence, field, store|
  #Use this method when modifying a richtext field in alchemy
  @alchemy_rand_string = ('a'..'z').to_a.shuffle[0,8].join.upcase
  if field == 'rich'
    if store
      @original_value = $test.current_page.get_original_text_value(essence)
      $old_val_richtext = $test.db.get_richtext_alchemy_essence(@original_value)
    end
    $test.current_page.edit_text_essence(essence, @alchemy_rand_string)

  elsif field == 'basic'
    if store
      @original_value = $test.current_page.get_original_text_value_basic(essence)
      $old_val = @original_value
    end
    $test.current_page.basic_edit(essence, @alchemy_rand_string)
  end
end

When(/^the user saves the alchemy page$/) do
  $test.current_page.click_save
  $test.current_page.wait_for_preview_to_update(@alchemy_rand_string)
end

When(/^the user publishes the alchemy page$/) do
  $test.current_page.click_publish
  $text_id = $test.db.get_text_alchemy_essence_id(@alchemy_rand_string) if $old_val
end

#THENS
Then(/^the user should see the new alchemy content on the page$/) do
  assert_text(@alchemy_rand_string)
end

Then (/^the user should not see any errors in the alchemy preview pane$/) do
  $test.current_page.preview_pane_no_errors?
end

Then /^the user resets the (.*) (text|field) on the (.*) page, then verifies on (.*)$/ do |essence, type, alchemy_page, page|
  step "the user visits the alchemy page"
  step "the user edits the #{alchemy_page} page"
  $test.current_page.edit_text_essence(essence, @original_value) if type == 'text'
  $test.current_page.basic_edit(essence, @original_value) if type == 'field'
  $test.current_page.click_save
  step "the user publishes the alchemy page"
  step "the user visits the #{page} page"
  assert_text(@original_value)
end
