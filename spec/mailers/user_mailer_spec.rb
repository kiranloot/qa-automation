require 'spec_helper'

describe UserMailer do
  let(:subscription) { create(:subscription) }

  describe '#reset_password_instructions' do
    before do
      @subscription = create(:subscription)
      @token = Devise.friendly_token
      @subscription.user.email = "test@mail.com"
      @user = @subscription.user
      @mock_mailer = double(:mail, deliver: true)
      allow_any_instance_of(MandrillMailer::TemplateMailer).to receive(:deliver).and_return(true)
    end

    it 'send reset password email' do
      expect(UserMailer).to receive(:reset_password_instructions).and_return(@mock_mailer)

      UserMailer.reset_password_instructions(@user, @subscription)
    end
  end
end