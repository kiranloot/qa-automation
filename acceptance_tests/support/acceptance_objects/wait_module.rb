module WaitForAjax

  def wait_for_ajax
    if ENV['BROWSER'] == 'safari' || ENV['DRIVER'] == 'appium'
      sleep(1)
    end
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until page.driver.evaluate_script('jQuery.active === 0')
    end
  end

end
