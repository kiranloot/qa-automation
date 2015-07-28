ActiveAdmin.register Affiliate do
  filter :name
  filter :redirect_url
  filter :active

  permit_params [:name, :redirect_url, :active]
end
