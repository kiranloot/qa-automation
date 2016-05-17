#GIVENS
Given /^the (.*) variant is sold out$/ do |sku|
  $test.db.sellout_variant(sku)
end

Given /^the (.*) product is sold out$/ do |product|
  $test.db.sellout_product(product)
end

Given /^The (.*) level up product is (.*)$/ do |product,inv_status|
  inv_status.strip!
  product.strip!
  case product
  when "socks"
    variant_id = $test.db.get_variant_id("unisex-socks","Loot Socks")
  when "accessory"
    variant_id = $test.db.get_variant_id("unisex-accessories","Loot for Her")
  end
  step "the user visits the admin page"
  step "logs in as an admin"
  $test.current_page.click_variants
  $test.current_page = AdminVariantsPage.new
  case inv_status
  when "sold out"
    $test.current_page.set_variant_inventory(variant_id,0)
  when "available"
    $test.current_page.set_variant_inventory(variant_id,30000)
  end
  step "logs out of admin"
  #$test.set_subject_user
end

#WHENS
When /^the user notes the current inventory count for their variant$/ do
  @old_inventory = $test.db.get_total_committed_by_sku($test.user.subscription.variant_sku).to_i
end

#THENS
Then /^the (mens|womens) (s|m|l|xl|2xl|3xl|4xl|5xl) option for level up tshirt should be soldout$/ do |gender, size|
  $test.current_page.lu_variant_sold_out?(gender, size)
end

Then /the (.*) crate should be sold out/ do |product|
  $test.current_page.sold_out?
end

Then /^the (.*) option should be soldout/ do |variant|
  $test.current_page.shirt_variant_soldout?(variant)
end

Then /^the landing page (should|should not) reflect the sellout$/ do |action|
  $test.current_page.page_scroll
  if action == 'should'
    expect(page).to have_css("#cms-core-crate-theme-section-soldout")
  elsif action == 'should not'
    expect(page).to have_no_css("#cms-core-crate-theme-section-soldout")
  end
end

Then /^the opc page (should|should not) reflect the sellout$/ do |action|
  $test.current_page.page_scroll
  if action == 'should'
    expect($test.current_page.crate_sold_out?).to be_truthy
  elsif action == 'should not'
    expect($test.current_page.crate_sold_out?).to be_falsey
  end
end

Then /^the total committed for the purchased crate should increase by one$/ do
  @inventory_increased = false
  10.times do
    @new_inventory = $test.db.get_total_committed_by_sku($test.user.subscription.variant_sku).to_i
    if (@new_inventory - @old_inventory) == 1
      @inventory_increased = true
      break
    else
      sleep(2)
    end
  end
  expect(@inventory_increased).to be true
end
