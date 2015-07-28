require 'rails_helper'

RSpec.describe SubscriptionSkippedMonth, type: :model do
  describe "Validations" do
    it { should validate_presence_of(:subscription_id) }
    it { should validate_presence_of(:month_year) }
    it { should validate_uniqueness_of(:month_year).scoped_to(:subscription_id) }
  end
end
