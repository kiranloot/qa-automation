
And(/^the crunchyroll user login with primium plus account$/) do
  page.find(:id, 'crunchyroll-cta').click
  cr_primium_plus_email = $test.user.crunchyroll_premium_plus_email
  cr_primium_pls_pwd = $test.user.crunchyroll_premium_plus_pwd
  $test.enter_crunchyroll_user(cr_primium_plus_email)
  $test.enter_crunchyroll_password(cr_primium_pls_pwd)
end

And(/^the verify crunchyroll (.*) month coupon applied$/) do |coupon|
  $test.crunchyroll_discount_applied(coupon)

  #Once verified reset the auth_provicer
end

And(/^the crunchyroll user login with primium account$/) do
  page.find(:id, 'crunchyroll-cta').click
  cr_primium_email = $test.user.crunchyroll_premium_email
  cr_primium_pwd = $test.user.crunchyroll_premium_pwd
  $test.enter_crunchyroll_user(cr_primium_email)
  $test.enter_crunchyroll_password(cr_primium_pwd)
end

And(/^the verify crunchyroll one month coupon is not applied$/) do
  $test.crunchyroll_discount_isnot_applied
end

And(/^the user delete crunchyroll_link with lootcrate account$/) do
  $test.delete_link_with_crunchyroll_account
end

And(/^the user links cruncyroll account$/) do
  mylink = page.find(".crunchy-roll-container a").click
  puts mylink
end

And(/^the user go to my_account$/) do
  $test.go_to_my_account
end

And(/^the user link LC account with crunchyroll account$/) do
  page.find(".cr_button").click
  cr_primium_plus_email = $test.user.crunchyroll_premium_plus_email
  cr_primium_pls_pwd = $test.user.crunchyroll_premium_plus_pwd
  $test.enter_crunchyroll_user(cr_primium_plus_email)
  $test.enter_crunchyroll_password(cr_primium_pls_pwd)
end

And(/^the cruncyroll account is verified$/) do
  $test.cr_account_verified
end