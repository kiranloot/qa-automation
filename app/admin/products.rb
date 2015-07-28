ActiveAdmin.register Product do
  actions :all, except: [:new, :create, :destroy]
  config.batch_actions = false

  permit_params [:description]
end
