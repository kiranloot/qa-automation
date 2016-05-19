
And(/^the crunchyroll user login with primium plus account$/) do
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
  cr_primium_email = $test.user.crunchyroll_premium_email
  cr_primium_pwd = $test.user.crunchyroll_premium_pwd
  $test.enter_crunchyroll_user(cr_primium_email)
  $test.enter_crunchyroll_password(cr_primium_pwd)
end

And(/^the verify crunchyroll one month coupon is not applied$/) do
  $test.crunchyroll_discount_isnot_applied
end

And(/^the user click delete button$/) do
  $test.delete_link_with_crunchyroll_account
end

And(/^the user links cruncyroll account$/) do
  sleep 5
  mylink = page.find(".crunchy-roll-container a").click
  puts mylink
end