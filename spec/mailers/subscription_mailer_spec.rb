require "spec_helper"

describe SubscriptionMailer do
  let(:subscription) { create(:subscription) }

  before do
    @mock_mailer = double(:mail, deliver: true)
    allow_any_instance_of(MandrillMailer::TemplateMailer).to receive(:deliver).and_return(true)
  end

  describe "signup" do
    before do
      @subscription = create(:subscription)
      @subscription.user.email = "test@mail.com"
      @user = @subscription.user
    end

    it "send welcome email" do
      expect(SubscriptionMailer).to receive(:signup).and_return(@mock_mailer)

      SubscriptionMailer.signup(@user, @subscription)
    end
  end

  describe "#cancel_at_end_of_period" do
    before do
      @cancellation_date = Time.now.tomorrow
    end

    it "sends cancel_at_end_of_period email" do
      expect(SubscriptionMailer).to receive(:cancel_at_end_of_period).and_return(@mock_mailer)

      SubscriptionMailer.cancel_at_end_of_period(subscription, @cancellation_date)
    end
  end

  describe "#reactivated_subscription" do
    it "sends reactivated_subscription email" do
      expect(SubscriptionMailer).to receive(:reactivated_subscription).and_return(@mock_mailer)

      SubscriptionMailer.reactivated_subscription(subscription)
    end
  end

  describe "#upgrade" do
    before do
      @adjusted_preview = {
        "migration" => {
          "prorated_adjustment" => -1000,
          "charge"              => 10599,
          "payment_due"         => 9599,
          "credit_applied"      => 0
        }
      }
    end

    it "sends an upgrade email" do
      expect(SubscriptionMailer).to receive(:upgrade).and_return(@mock_mailer)

      SubscriptionMailer.upgrade(subscription)
    end
  end
end
