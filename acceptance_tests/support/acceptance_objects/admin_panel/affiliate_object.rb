require_relative "admin_object"
class AdminAffiliatesPage < AdminPage
  def initialize
    super
  end

  def create_affiliate
    $test.affiliate = FactoryGirl.build(:affiliate)
    page.find_link('New Affiliate').click
    fill_in("affiliate_name", :with => $test.affiliate.name)
    fill_in("affiliate_redirect_url", :with => $test.affiliate.redirect_url)
    page.find_field("Active").click
    page.find_button("Create Affiliate").click
    wait_for_ajax
  end

end
