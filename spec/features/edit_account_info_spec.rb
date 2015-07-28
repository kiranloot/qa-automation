feature 'Edit Account Info' do
  
  given(:subscription) do 
    create(:subscription, 
      subscription_periods: [build(:active_subscription_period)]) 
  end
  given(:user) { create(:user, subscriptions: [subscription]) }
  given(:account_page) { UserAccountPageObject.new }

  background do
    login_as user, scope: :user
    allow_any_instance_of(User).to receive(:sync_subscriptions!).and_return(nil)
    account_page.visit_page
  end

  scenario 'updating full name field' do
    account_page.update_full_name('Ronald McDonald')

    expect(page).to have_content('Ronald McDonald')
    expect(user.reload.full_name).to eq('Ronald McDonald')
  end

  scenario 'updating email address' do
    account_page.update_email_address('test@example.com')

    expect(page).to have_content('test@example.com')
    expect(user.reload.email).to eq('test@example.com')
  end

  scenario 'updating password' do
    account_page.update_password('please', 'password')
    
    expect(user.encrypted_password).to_not eq(user.reload.encrypted_password)
  end


end