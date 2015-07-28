require 'spec_helper'

feature 'International subscribers', :js => true do
  before(:each) do 
    Rails.cache.clear
  end

  let(:country_ips) do
    {
      canada: '192.206.151.131',
      russia: '95.108.142.138',
      united_states: '104.33.44.239'
    }
  end

  scenario 'navigate to checkout page as canadian user' do
    create(:plan_ca)
    create(:plan_ca_3_months)
    create(:plan_ca_6_months)

    allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(country_ips[:canada])
    visit '/'
    expect(page.body).to match(/ca-1-month-subscription/)

    # now come back from russia and make sure our cookie is used
    allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(country_ips[:russia])

    visit '/'
    expect(page.body).to match(/ca-1-month-subscription/)
  end

  # TODO: Commented out for now. This is a bug(minor?).
  # scenario 'navigate to checkout page as russian user' do
  #   create(:plan)
  #   create(:plan_3_months)
  #   create(:plan_6_months)

  #   allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(country_ips[:russia])

  #   visit '/'
  #   expect(page.body).to match(/1-month-subscription/)

  #   # now come back from canada and make sure no cookie had been written
  #   allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(country_ips[:canada])
  #   visit '/'
  #   expect(page.body).to match(/ca-1-month-subscription/)
  # end

  scenario 'navigate to checkout page as US' do
    create(:plan)
    create(:plan_3_months)
    create(:plan_6_months)

    allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(country_ips[:united_states])
    visit '/'

    expect(page.body).to match(/1-month-subscription/)
  end

  # all jacked b/c of dynamically added shipping dropdown
=begin
  scenario 'navigate to checkout page as canadian', disabled: true do
    visit '/'
    expect(page).to have_content 'Not your country?'
    find_link('canada-beta').trigger('click')

    expect(page).to have_content 'No Additional Shipping & Handling!'
    find_link('SELECT', :match => :first).trigger("click")

    expect(page).to have_content 'CREATE YOUR ACCOUNT'
    within("form#new_user", :match => :first) do
      fill_in 'Email', :with => 'capy@bara.com'
      fill_in 'Password', :with => 'password'
      click_on 'SIGN UP'
    end

    expect(page).to have_content 'SUBSCRIPTION DETAILS'

    page.should have_selector("#subscription_shipping_address_attributes_country") do |content|
      content.should have_selector(:option, :value => "PLEASE SELECT")
      content.should have_selector(:option, :value => "Canada")
      content.should have_selector(:option, :selected => "Canada")
    end
  end
=end
end
