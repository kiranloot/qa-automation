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
    find_link(link).click
    wait_for_ajax
  end

  def login_to_alchemy(username, password)
    unless page.has_content?("Welcome back")
      fill_in('cms_user_email', :with => username)
      fill_in('cms_user_password', :with => password)
      find_button("Log in").click
    end
    wait_for_ajax
  end

  def edit_text_essence(essence_name, text)
    find(:css, 'label', :text => essence_name).find(:xpath,".//..").fill_in('tinymce',:with => text)
  end

  def click_save
    click_button("Save")
    wait_for_ajax
  end

  def click_publish
    find(:css, 'button span.publish').click
    wait_for_ajax
  end
end
