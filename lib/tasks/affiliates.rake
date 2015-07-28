require 'yaml'

affiliates = YAML.load_file('db/affiliates.yml')

namespace :affiliates do
  desc 'populate affiliates'
  task populate: :environment do
    affiliates.each do |affiliate|
      Rails.logger.info ('Forward name: ' + affiliate['name'])
      # Affiliate.create name: affiliate['name'], redirect_url: affiliate['redirect_url'], active: true
      Affiliate.where(name: affiliate['name']).first_or_create.update_attributes({name: affiliate['name'], redirect_url: affiliate['redirect_url'], active: true})
    end

    puts 'Affiliates added'
  end
end
