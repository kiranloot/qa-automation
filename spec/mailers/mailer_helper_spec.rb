require 'spec_helper'

describe MailerHelper do
  describe "#delivery_subscription_month" do
    let(:dummy_class) { Class.new {include MailerHelper} }
    let(:subscription) { OpenStruct.new }

    context 'Jan 18, 11PM' do
      it 'should return Jan' do
        subscription.created_at = Time.local(2015, 1, 18, 23, 0, 0).in_time_zone("Pacific Time (US & Canada)")

        result = dummy_class.new.delivery_subscription_month(subscription)
        expect(result).to eq "January"
      end
    end

    context 'Jan 19, 8PM' do
      it 'should return Jan' do
        subscription.created_at = Time.local(2015, 1, 19, 20, 0, 0).in_time_zone("Pacific Time (US & Canada)")

        result = dummy_class.new.delivery_subscription_month(subscription)
        expect(result).to eq "January"
      end
    end
    context 'Jan 19, 9PM' do
      it 'should return Feb' do
        subscription.created_at = Time.local(2015, 1, 19, 23, 0, 1).in_time_zone("Pacific Time (US & Canada)")

        result = dummy_class.new.delivery_subscription_month(subscription)
        expect(result).to eq "February"
      end
    end

    context 'Jan 20, 1AM' do
      it 'should return Feb' do
        subscription.created_at = Time.local(2015, 1, 20, 1, 0, 0).in_time_zone("Pacific Time (US & Canada)")

        result = dummy_class.new.delivery_subscription_month(subscription)
        expect(result).to eq "February"
      end
    end

    context 'Feb 1, 2015' do
      it 'should return Feb' do
        subscription.created_at = Time.local(2015, 2, 1, 2, 0, 0).in_time_zone("Pacific Time (US & Canada)")

        result = dummy_class.new.delivery_subscription_month(subscription)
        expect(result).to eq "February"
      end
    end
  end

end
