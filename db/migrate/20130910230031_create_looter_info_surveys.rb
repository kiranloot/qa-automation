class CreateLooterInfoSurveys < ActiveRecord::Migration
  def change
    create_table :looter_info_surveys do |t|
      t.string  :looter_name
      t.string  :email
      t.string  :shirt_size
      t.boolean :used, :default => false

      t.timestamps
    end
  end
end
