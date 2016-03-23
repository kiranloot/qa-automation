require_relative "admin_object"
class AdminShippingManifestsPage < AdminPage
  def initialize
    super
  end

  def manifest_page_loaded?
    expect(find(:id, 'page_title').text).to eq("SHIPPING MANIFESTS")
  end

  def click_request_manifest
    click_link('Request Shipping Manifest CSV')
    expect(find("div.flash_notice")).to be_truthy
  end

  def click_manifest_list
    click_link('Shipping Manifest CSV List')
    expect(find('.admin_shipping_fulfillment_csvs')).to be_truthy
    $test.current_page = AdminShippingManifestCSVListPage.new
  end
end
