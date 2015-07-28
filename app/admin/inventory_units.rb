ActiveAdmin.register InventoryUnit do
  actions :all, except: [:new, :create, :destroy]
  config.batch_actions = false

  form do |f|
    f.inputs "#{resource.variant.product.name} (#{resource.variant.name})" do
      f.input :total_available, hint: "Total committed: #{resource.total_committed}"
      f.input :in_stock
    end
    f.actions
  end

  permit_params [:total_available, :in_stock]
end
