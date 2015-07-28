feature 'visitor registers for an account' do

  given(:welcome_page) { WelcomePageObject.new }
  given(:login_page) { LoginPageObject.new }
  given(:visitor) { FactoryGirl.build(:user, email: 'test@example.com', password: 'password') }
  
  background do
    create_default_plans
  end

  scenario 'visitor registers from the popup modal' do 
    welcome_page.visit_page
    welcome_page.close_newsletter_modal
    welcome_page.open_register_modal
    welcome_page.fill_in_new_account_info visitor
    welcome_page.click_create_account
    
    expect(current_path).to eq(user_accounts_path)
    expect(User.count).to eq(1)
  end

  scenario 'visitor registers from the sign up page' do
    login_page.visit_page
    login_page.click_one_month
    login_page.register visitor

    expect(current_path).to eq(new_checkout_path('1-month-subscription'))
    expect(User.count).to eq(1)
  end


private

  def create_default_plans
    @one_month_plan = FactoryGirl.create(:plan)
  end

end