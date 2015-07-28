namespace :db_tools do
  desc 'Add a admin'
  task add_admin: :environment do
    user = User.create! email: 'admin@lootcrate.com', password: 'l00tcr4t3'
    user.add_role :admin
  end
end
