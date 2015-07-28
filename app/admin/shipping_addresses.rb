ActiveAdmin.register ShippingAddress do
  actions :all, except: [:new, :create, :destroy]
  menu parent: "More", :if => proc{ !GlobalConstants::BLOCK_ADMIN_USERS }

  index do
    column :id
    column :full_name do |addr|
      "#{addr.first_name} #{addr.last_name}"
    end
    column :line_1
    column :line_2
    column :city
    column :state do |addr|
      "#{addr.readable_state} (#{addr.state})"
    end
    column :zip
    column :country

    unless GlobalConstants::BLOCK_ADMIN_USERS
      actions
    end
  end

  filter :line_1
  filter :line_2
  filter :state
  filter :city
  filter :zip
  filter :first_name
  filter :last_name
  filter :country 

  controller do
    def update
      @subscription = resource.subscriptions.first
      @error_messages = []
      @address_changer = ShippingAddress::Changer.new(resource, @subscription, permitted_params[:shipping_address])

      begin
        @address_changer.perform
        @error_messages += @address_changer.errors.full_messages
      rescue => e
        @error_messages << e.message
      end

      if @error_messages.any?
        flash.now[:error] = "Address update failed. Reason: #{@error_messages.to_sentence}"
        render :edit
      else
        flash[:notice] = "Address was successfully updated."
        redirect_to admin_shipping_address_path(resource)
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :line_1
      f.input :line_2
      f.input :city
      f.input :state
      f.input :zip
      f.input :country
    end
    f.actions
  end

  permit_params :first_name, :last_name, :line_1, :line_2, :city, :state, :zip, :country
end
