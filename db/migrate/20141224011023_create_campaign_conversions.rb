class CreateCampaignConversions < ActiveRecord::Migration
  def change
    create_table :campaign_conversions do |t|
      t.string :utm_source
      t.string :utm_campaign
      t.string :utm_medium
      t.references :user

      t.timestamps
    end
    add_index :campaign_conversions, :user_id
  end
end
