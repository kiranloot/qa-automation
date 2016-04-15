require_relative "page_object"

class AlchemyPage < Page
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "alchemy"
    setup
  end

  def visit_page
    visit @base_url
    $test.current_page = self
  end

  def navigate_to(entry)
    find(:css, "a.main_navi_entry > label", :text => entry).click
    wait_for_ajax
  end

  def open_alchemy_page(link)
    find(:id, 'sitemap').find_link(link).click
    wait_for_ajax
  end

  def login_to_alchemy(username, password)
    if page.has_css?("#cms_user_email")
      fill_in('cms_user_email', :with => username)
      fill_in('cms_user_password', :with => password)
      find_button("Log in").click
    end
    wait_for_ajax
  end

  def get_original_text_value(essence_name)
    iframe_id = find(:css, 'label', :text => essence_name).first(:xpath,'.//..').find(:css, 'iframe')[:id]
    within_frame(iframe_id){
      el = find(:id, 'tinymce').text
      return el
    }
  end

  def get_original_text_value_basic(essence_name)
    find(:css, 'label', :text => essence_name).first(:xpath,'.//..').find('input[type=text]').value
  end

  def edit_text_essence(essence_name, text)
    iframe_id = find(:css, 'label', :text => essence_name).first(:xpath,'.//..').find(:css, 'iframe')[:id]
    within_frame(iframe_id){
      el = find(:id, 'tinymce')
      # el.click
      # el.send_keys(text)
      el.set(text)
    }
  end

  def basic_edit(essence_name, text)
    field = find(:css, 'label', :text => essence_name).first(:xpath,'.//..').find('input[type=text]')
    field.click
    field.set(text)
  end

  def wait_for_preview_to_update(text)
    within_frame('alchemy_preview_window'){
      page.has_content?(text)
    }
  end

  def click_save
    click_button("Save")
    wait_for_ajax
    find('div#flash_notices')
  end

  def click_publish
    find(:css, 'button span.publish').click
    wait_for_ajax
    find('div#flash_notices')
  end

  def preview_pane_no_errors?
    iframe
    within_frame('alchemy_preview_window'){
      no_errors?
    }
  end

  private
  def iframe
    find('iframe#alchemy_preview_window')
  end
end
