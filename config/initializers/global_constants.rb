# Be sure to restart your server when you modify this file.

module GlobalConstants

  # set these config vars, if not in environment, default to false, (but they really really should be in the environment)
  SHOWCOUNTDOWN = ENV['SHOWCOUNTDOWN'] == "true" ? true : false
  THEMEREVEAL = ENV['THEMEREVEAL'] == "true" ? true : false
  SOLDOUT = ENV['SOLDOUT'] == "true" ? true : false # This will stop signups and divert people to the sold_out page (waitlist). Be sure to update the sold_out page.
  SOLDOUT_AMIIBO = ENV['SOLDOUT_AMIIBO'] == "true" ? true : false # This will stop signups and divert people to the sold_out page (waitlist). Be sure to update the sold_out page.
  CUTOFF_AMIIBO = ENV['CUTOFF_AMIIBO'] ? ENV['CUTOFF_AMIIBO'] : 2849 # The max amount of amiibo crates to sell, (2849 is experiment)
  BLOCK_ADMIN_USERS = ENV['BLOCK_ADMIN_USERS'] == 'true' ? true : false

  SHIPPING_COUNTRIES = ["United States", "Canada", "United Kingdom", "Australia", "Denmark", "Germany", "Ireland", "Netherlands", "Norway", "Sweden", "Finland", "France", "New Zealand"]
  SHIPPING_COUNTRIES_CODE = ["US", "CA", "GB", "AU", "DK", "DE", "IE", "NL", "NO", "SE", "FI", "FR", "NZ"]
  READABLE_SHIRT_SIZES = ["Mens - S", "Mens - M", "Mens - L",
                          "Mens - XL", "Mens - XXL", "Mens - XXXL",
                          "Womens - S", "Womens - M", "Womens - L",
                          "Womens - XL", "Womens - XXL", "Womens - XXXL"]
  SHIRT_SIZES = ["M S", "M M", "M L", "M XL", "M XXL", "M XXXL",
                 "W S", "W M", "W L", "W XL", "W XXL", "W XXXL"]
  LOCALES = { "US" => :en,  "CA" => :'en-CA', "GB" => :'en-GB', "AU" => :'en-AU', "DE" => :de, "DK" => :da,  "IE" => :'en-IE', "NL" => :nl, "NO" => :nb, "SE" => :sv, "FI" => :fi, "FR" => :fr, "NZ" => :'en-NZ' }

  # add all possible querystring args that denote country
  PLAN_COUNTRIES = {
        'AU' => 'AU', 'CA' => 'CA', 'DE' => 'DE', 'DK' => 'DK', 'FI' => 'FI', 'FR' => 'FR', 'GB' => 'GB', 'IE' => 'IE', 'NL' => 'NL', 'NO' => 'NO', 'NZ' => 'NZ', 'SE' => 'SE', 'US' => 'US',
        "#{Settings.au_one_month_sub}" => 'AU',
        "#{Settings.au_three_month_sub}" => 'AU',
        "#{Settings.au_six_month_sub}" => 'AU',
        "#{Settings.au_twelve_month_sub}" => 'AU',
        "#{Settings.ca_one_month_sub}" => 'CA',
        "#{Settings.ca_three_month_sub}" => 'CA',
        "#{Settings.ca_six_month_sub}" => 'CA',
        "#{Settings.ca_twelve_month_sub}" => 'CA',
        "#{Settings.de_one_month_sub}" => 'DE',
        "#{Settings.de_three_month_sub}" => 'DE',
        "#{Settings.de_six_month_sub}" => 'DE',
        "#{Settings.de_twelve_month_sub}" => 'DE',
        "#{Settings.dk_one_month_sub}" => 'DK',
        "#{Settings.dk_three_month_sub}" => 'DK',
        "#{Settings.dk_six_month_sub}" => 'DK',
        "#{Settings.dk_twelve_month_sub}" => 'DK',
        "#{Settings.fi_one_month_sub}" => 'FI',
        "#{Settings.fi_three_month_sub}" => 'FI',
        "#{Settings.fi_six_month_sub}" => 'FI',
        "#{Settings.fi_twelve_month_sub}" => 'FI',
        "#{Settings.fr_one_month_sub}" => 'FR',
        "#{Settings.fr_three_month_sub}" => 'FR',
        "#{Settings.fr_six_month_sub}" => 'FR',
        "#{Settings.fr_twelve_month_sub}" => 'FR',
        "#{Settings.gb_one_month_sub}" => 'GB',
        "#{Settings.gb_three_month_sub}" => 'GB',
        "#{Settings.gb_six_month_sub}" => 'GB',
        "#{Settings.gb_twelve_month_sub}" => 'GB',
        "#{Settings.ie_one_month_sub}" => 'IE',
        "#{Settings.ie_three_month_sub}" => 'IE',
        "#{Settings.ie_six_month_sub}" => 'IE',
        "#{Settings.ie_twelve_month_sub}" => 'IE',
        "#{Settings.nl_one_month_sub}" => 'NL',
        "#{Settings.nl_three_month_sub}" => 'NL',
        "#{Settings.nl_six_month_sub}" => 'NL',
        "#{Settings.nl_twelve_month_sub}" => 'NL',
        "#{Settings.no_one_month_sub}" => 'NO',
        "#{Settings.no_three_month_sub}" => 'NO',
        "#{Settings.no_six_month_sub}" => 'NO',
        "#{Settings.no_twelve_month_sub}" => 'NO',
        "#{Settings.nz_one_month_sub}" => 'NZ',
        "#{Settings.nz_three_month_sub}" => 'NZ',
        "#{Settings.nz_six_month_sub}" => 'NZ',
        "#{Settings.nz_twelve_month_sub}" => 'NZ',
        "#{Settings.se_one_month_sub}" => 'SE',
        "#{Settings.se_three_month_sub}" => 'SE',
        "#{Settings.se_six_month_sub}" => 'SE',
        "#{Settings.se_twelve_month_sub}" => 'SE',
        "#{Settings.one_month_sub}" => 'US',
        "#{Settings.three_month_sub}" => 'US',
        "#{Settings.six_month_sub}" => 'US',
        "#{Settings.six_month_sub}" => 'US',
        "#{Settings.amiibo_crate_three_weekly_payments}" => 'US',
        "#{Settings.amiibo_crate_single_payment}" => 'US'
      }
end

PHASE_1 = false
