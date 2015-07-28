class AddAffiliatesTable < ActiveRecord::Migration
  def change
    create_table :affiliates do |t|
      t.string :name
      t.string :redirect_url
    end
  end
end
