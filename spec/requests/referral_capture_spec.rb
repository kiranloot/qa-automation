require 'spec_helper'


describe "A visitor visits the home page" do

  before do
    create(:plan)
    create(:plan_3_months)
    create(:plan_6_months)
  end

  describe "not through a referral" do
    it 'does not set the referral cookie' do
      expect(cookies['lc_utm']).to be_nil
      get root_path
      expect(cookies['lc_utm']).to be_nil
    end
  end

  describe "through a referral" do

    it "sets the cookie" do
      expect(cookies['lc_utm']).to eq nil

      utm = {
        "utm_source" => 'abc',
        "utm_campaign" => 'lootcrate-test',
        "utm_medium" => 'internet_radio',
        "utm_term" => nil,
        "utm_content" => nil
      }
      get root_path, utm
      expect(JSON.parse(cookies['lc_utm'])).to eq utm 
    end
  end

  def login(user)
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
  end

end
