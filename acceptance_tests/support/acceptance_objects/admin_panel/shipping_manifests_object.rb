require_relative "admin_object"
class AdminShippingManifestsPage < AdminPage
  def initialize
    super
  end

  def manifest_page_loaded?
    expect(find_element(:id, 'page_title').text).to eq("Shipping Manifests")
  end
end
