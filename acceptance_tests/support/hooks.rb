require 'yaml'
require 'pry'
require 'factory_girl'
require 'active_support'
require 'rspec/expectations'
require 'platform-api'
Dir["acceptance_objects/*"].each do |file|
  puts file
  require file
end

ENV['ASPECTOR_LOG_LEVEL'] = 'NONE'

env = ENV['SITE']

box = Box.new(env)

$env_base_url = box.base_url

$env_test_data_file_path ||= "acceptance_tests/support/qa_test_data.yml"
test_data = YAML.load(File.open($env_test_data_file_path))

pages = {
  home: HomePage, 
  signup: SignupPage, 
  #checkout: CheckoutPage, 
  #subscribe: SubscribePage,
  my_account: MyAccountPage, 
  #mailinator: Mailinator, 
  admin: AdminPage, 
  upgrade: UpgradePage,
  levelup_subscribe: LevelUpSubscribePage, 
  fallout4: Fallout4Page, 
  lootcrate_landing: LootcrateLandingPage,
  lootcrate_subscribe: LootcrateSubscribePage,
  lootcrate_checkout: LootcrateCheckoutPage,
  anime_landing: AnimeLandingPage,
  anime_subscribe: AnimeSubscribePage,
  anime_checkout: AnimeCheckoutPage,
  pets_landing: PetsLandingPage,
  pets_subscribe: PetsSubscribePage,
  pets_checkout: PetsCheckoutPage,
  pewdiepie: PewdiepiePage, 
  boogie2988: Boogie2988Page, 
  tradechat: TradeChat,
  alchemy: AlchemyPage,
  about_us: AboutUsPage
}

Before do
  Capybara.default_max_wait_time = 15
  Capybara.use_default_driver
  unless ENV['DRIVER'] == 'appium'
    page.driver.browser.manage.window.move_to(0, 0)
    page.driver.browser.manage.window.resize_to(1800, 1100)
  end
  visit $env_base_url
  $test = Test.new( test_data, HomePage.new, pages, DBCon.new, box, MailinatorAPI.new)
  $test.user = User.new($test)
  $test.admin_user = FactoryGirl.build(:user, :admin)
  #If US flag isn't showing, set it to US
  if(!$test.user.is_country_us?)
    $test.user.set_ship_to_country("United States")
  end
end

Before ('@alchemy_text') do 
  $text_id = $test.db.get_richtext_alchemy_essence_id("What is Loot Crate™?")
end

After do
  $test.db.finish
  unless ENV['DRIVER'] == 'appium'
    reset_session!
  end
  page.execute_script "window.close();"
end

After ('@alchemy_text') do 
  $test.db.set_richtext_alchemy_essence_to($text_id, "<p>What is Loot Crate™?</p>", 'What is Loot Crate™?')
end
