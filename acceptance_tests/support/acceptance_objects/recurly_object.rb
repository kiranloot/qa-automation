class RecurlyPage < Page
  require 'aspector'
  require_relative 'wait_module'
  include WaitForAjax
  @@set_one = [:on_account_tab, :on_subscriptions_tab]
  def initialize
    super
    @page_type = "recurly"
    @email_login = "user_email"
    @password_login = "user_password"
    @recurly_email = "chris.lee@lootcrate.com"
    @recurly_password = "testrecurlymore12345!"
    @site_menu = "#sites_menu > div > div > div"
    setup
  end

  def recurly_login
    for i in 0..2
      if page.has_content?("Recurly") && page.has_content?("LOG IN")
        page.find_link("Log in").click
        break
      end
    end

    for x in 0..2 
      if page.has_content?("Forgot password?")
        fill_in(@email_login, :with => @recurly_email)
        fill_in(@password_login, :with => @recurly_password)
        break
      end
    end

    page.find_button("Log in").click
  end

  def be_at_recurly_sandbox
    if current_url.include?("recurly") && current_url.include?("sandbox") 
      return
    else
      if current_url.include?("recurly")
        switch_to_sandbox
      else
        visit $base_url
        recurly_login
        switch_to_sandbox
      end
    end
  end

  def on_account_tab
    find_link("Accounts").click
  end

  def on_subscriptions_tab
    find_link("Subscriptions").click
  end

  def filter_for_user_by_name
    wait_for_ajax
    page.fill_in("q", :with => $test.user.full_name)
    page.find('#q').native.send_key(:enter)
  end

  def filter_for_user_by_email
    wait_for_ajax
    page.fill_in('q', :with => $test.user.email)
  end

  @@set_one.each do |name|
    aspector do
      before name do
        be_at_recurly_sandbox
      end
    end
  end

  def switch_to_sandbox
    page.find(@site_menu).click
    page.find_link("Loot Crate Sandbox").click
  end

end

