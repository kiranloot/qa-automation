class CreateOrdersCsvs < ActiveRecord::Migration
  def change
    create_table :orders_csvs do |t|
      t.string  :url
      t.string  :status, default: "pending"
      t.integer :job_id

      t.timestamps
    end
  end
end
