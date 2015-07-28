module ControllerMacros
  shared_context 'login_admin' do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @admin_user = FactoryGirl.create(:admin_user)
      sign_in @admin_user
    end
  end

  shared_context 'login_user' do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the confirmable module
      sign_in @user
      allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
    end
  end

  shared_context 'force_ssl' do
    before(:each) do
      request.env["rack.url_scheme"] = "https"
    end
  end

  shared_context 'plan_seed' do
    before(:each) do
      load "#{Rails.root}/db/seeds.rb"
    end
  end
end