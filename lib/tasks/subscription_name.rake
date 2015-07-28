namespace :subscription_name do
  desc 'populate subscription name'
  task populate: :environment do

    User.includes(:subscriptions).find_each do |user|
      user.subscriptions.each_with_index do |subscription, index|
        subscription.update_attribute(:name, "Subscription #{index+1}")
        puts "Update subscriptions of #{user.email}"
      end
    end

    puts "Update subscription names successfully"
  end
end
