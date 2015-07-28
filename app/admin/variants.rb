ActiveAdmin.register Variant do
  actions :all, except: [:edit, :new, :create, :destroy]
  config.batch_actions = false

  index do
    column :id
    column :sku
    column :name
    column :is_master
    column 'Total Commited' do |variant|
      variant.inventory_unit_total_committed
    end
    column 'Total Available' do |variant|
      variant.inventory_unit_total_available
    end
    column 'In Stock?' do |variant|
      variant.in_stock?
    end

    actions defaults: true do |variant|
      link_to 'Change Inventory', edit_admin_inventory_unit_path(variant.inventory_unit)
    end
  end

  controller do
    def scoped_collection
      super.includes :inventory_unit
    end
  end

  permit_params []
end
