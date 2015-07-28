require 'securerandom'
require 'csv'

namespace :revert do
  desc 'Migrate lootcrate spree users back to legacy'

  task create_chargify_customers: :environment do |args|
    CSV.open('chargify_customer_mapping_store_1.csv', 'r') do |csv|
      csv.each do |row|
        user = User.find_by_email row[0]
        user.chargify_customer_accounts << ChargifyCustomer.create(chargify_customer_id: row[1]) rescue nil
      end
    end
    CSV.open('chargify_customer_mapping_store_2.csv', 'r') do |csv|
      csv.each do |row|
        user = User.find_by_email row[0]
        user.chargify_customer_accounts << ChargifyCustomer.create(chargify_customer_id: row[1],braintree: true)
      end
    end
  end
  task :migrate_spree_users_to_legacy => :environment do |args|
    CSV.open('spree_users.log', 'r') do |csv|
      while row = csv.shift
        email = row[0]
        encrypted_password = row[1]
        password = row[2]
        account_status = row[3]
        full_name = row[4]
        password_salt = row[5]

        user = User.find_by_email email

        if user
          puts "found #{email}"
        else
          user = User.new(
            email: email,
            password: password,
            password_confirmation: password,
            account_status: account_status,
            full_name: full_name
          )
          user.spree_password_hash = encrypted_password
        end

        user.spree_password_hash = encrypted_password
        user.spree_password_salt = password_salt

        begin
          user.save!
        rescue => e
          puts "problem with #{email}: #{e}"
        end
      end
    end
  end
end
