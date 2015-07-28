ActiveAdmin.register LooterInfoSurvey do
  menu parent: "More", :if => proc{ !GlobalConstants::BLOCK_ADMIN_USERS }

  active_admin_import

  filter :email, as: :string, filters: ['equals', 'contains', 'starts_with', 'ends_with']
  filter :shirt_size, as: :select, collection: ['M S', 'M M', 'M L', 'M XL', 'M XXL', 'M XXXL', 'W S', 'W M', 'W L', 'W XL', 'W XXL', 'W XXXL']
  filter :used
  filter :created_at
  filter :updated_at

  permit_params [:looter_name, :email, :shirt_size, :used]
end
