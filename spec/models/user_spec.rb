require 'spec_helper'

describe User do
  # setup
  # validation rules
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.not_to allow_value("12345").for(:password) }
  it { is_expected.to allow_value("123456").for(:password) }

  describe "#versions" do
    let(:user) { create(:user) }

    it 'tracks changes to watched attributes', versioning: true do
      user.update_attributes(email: 'trogdor@burn.inator')
      expect(user.versions.count).to eq(2)

      user.email = 'strong@bad.email'
      user.save
      expect(user.versions.count).to eq(3)
    end

    it 'does not track changes to ignored attribute', versioning: true do
      user.update_attributes(last_sign_in_ip: '1.1.1.1')
      expect(user.versions.count).to eq(1)

      user.last_sign_in_ip = '2.2.2.2'
      user.save
      expect(user.versions.count).to eq(1)
    end
  end

  describe "#is_new_subscriber" do
    context 'new subscriber' do
      it 'returns true' do
        user = create(:user_with_one_subscription)
        expect(user.is_new_subscriber?).to be_truthy
      end
    end

    context 'returning subscriber' do
      it 'returns false' do
        user = create(:user_with_multiple_subscriptions)
        expect(user.is_new_subscriber?).to be_falsey
      end
    end
  end

  describe "#emails" do
    let(:user) { create(:user) }
    let!(:emails) { [] << user.email }

    context "when there are multiple emails" do
      it "returns an array of emails that a user used", versioning: true do
        user.update_attributes(email: 'whatever@gmail.com')
        user.reload

        emails << user.email

        expect(user.emails).to match_array emails
      end
    end

    context "when there is an update that doesn't change email" do
      it "returns an array with one email" do
        user.update_attributes(full_name: 'whatever')
        user.reload

        expect(user.emails).to match_array emails.uniq
      end
    end
  end

  describe "#get_zendesk_tickets", versioning: true do
    let(:user) { create(:user, email: 'howhmn+33333@gmail.com') }
    before do
      collection = double("collection")
      allow_any_instance_of(Zendesk::API).to receive(:search_tickets_by_email).and_return(collection)
      ticket = double("ticket")
      allow(collection).to receive(:fetch).and_return(ticket)
    end

    it "returns all zendesk tickets that belongs to a user by their email(s)" do
      # add a second email to user.emails
      user.update_attributes(email: 'test@test.com')
      
      tickets = user.get_zendesk_tickets

      expect(tickets.length).to eq(user.emails.length)
    end
  end

  # chargify syncing utility methods
  describe 'with one chargify customer to many subscriptions' do
    before :each do
      # create customer
      @user = FactoryGirl.create(:user)

      params = {
        plan: "1-month-subscription",
        subscription: {
          billing_address_attributes:  FactoryGirl.attributes_for(:billing_address),
          shipping_address_attributes: FactoryGirl.attributes_for(:shipping_address),
          credit_card: {
            :number     => '1',
            :cvv        => '111',
            :expiration => Date.new(2023, 6)
          }
        }
      }

      # create chargify customer with 2 subscriptions
      sub = Local::Chargify::Subscription.new(params, @user).create
      customer = sub.customer
      params[:customer_id] = customer.id
      subs = [sub, Local::Chargify::Subscription.new(params, @user).create]

      # remap chargify customer account with customer id
      @user.chargify_customer_accounts << ChargifyCustomer.create(chargify_customer_id: customer.id)

      # remap chargify subscriptions account with customer id
      @user.subscriptions << FactoryGirl.create(:subscription,
                                                plan_id: 1,
                                                customer_id: customer.id,
                                                chargify_subscription_id: subs.first.id)
      @user.subscriptions << FactoryGirl.create(:subscription,
                                                plan_id: 1,
                                                customer_id: customer.id,
                                                chargify_subscription_id: subs.last.id)
      @user.save
    end
  end

  # === Scopes
  describe "#store_credits" do
    let(:user) { create(:user, email: 'testcase@lootcrate.com') }
    it 'returns store credit by user email' do
      store_credit = create(:store_credit, referrer_user_email: 'testcase@lootcrate.com',
        referrer_user_id: nil)

      expect(user.store_credits.first).to eq store_credit
    end

    it 'returns store credit by user id' do
      store_credit = create(:store_credit, referrer_user_id: user.id,
        referrer_user_email: nil)

      expect(user.store_credits.first).to eq store_credit
    end
  end

  describe "total_store_credits" do
    let(:user) { create(:user, email: 'testcase@lootcrate.com') }
    it 'returns total store credit' do
      create(:store_credit, referrer_user_email: 'testcase@lootcrate.com',
             amount: '2.01', friendbuy_conversion_id: '321', status: 'pending')
      create(:store_credit, referrer_user_email: 'testcase@lootcrate.com',
             amount: '1.02', friendbuy_conversion_id: '123', status: 'active')

      expect(user.total_store_credits).to eq(3.03)
    end

    it 'returns 0 for users with no store credits' do
      expect(user.total_store_credits).to eq(0)
    end
  end

end
