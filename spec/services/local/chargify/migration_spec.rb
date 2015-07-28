require 'spec_helper'

describe Local::Chargify::Migration do
  describe "#preview(product_handle)" do
    let(:subscription) { build(:subscription) }
    let(:product_handle) { '6-month-subscription' }

    context "when request is valid" do
      it "returns calculated migration values" do
        migration = Local::Chargify::Migration.new(subscription.chargify_subscription_id, product_handle)

        VCR.use_cassette 'subscription/migration_preview_success', match_requests_on: [:method, :uri_ignoring_id] do
          result = migration.preview

          expect(result['migration']).to_not eq nil
        end
      end
    end

    context "when request is invalid" do
      it "returns errors" do
        migration = Local::Chargify::Migration.new(subscription.chargify_subscription_id, 'does-not-exist')

        VCR.use_cassette 'subscription/migration_preview_fail', match_requests_on: [:method, :uri_ignoring_id] do
          result = migration.preview

          expect(result['errors']).to_not eq nil
        end
      end
    end
  end
end