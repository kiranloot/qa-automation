class AddNextAssessmentAtToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :next_assessment_at, :datetime
  end
end
