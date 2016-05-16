require_relative "admin_object"
require_relative "../modules/download_helpers"
class AdminShippingManifestCSVListPage < AdminPage
  include DownloadHelpers
  def initialize
    super
  end

  def aasm_completed?
    first('td.col-aasm_state').text == 'completed_successfully'
  end

  def click_first_view_link
    first('td.col-actions').click_link('View')
    expect(find('.row-csv_filename')).to be_truthy
  end

  def click_download
    unless ENV['DRIVER'] == 'remote'
      find('#titlebar_right').click_link('Download')
      download_content
    end
  end

  def verify_download
    unless ENV['DRIVER'] == 'remote'
      expect(downloads.any?).to be_truthy
      clear_downloads
    end
  end
end
