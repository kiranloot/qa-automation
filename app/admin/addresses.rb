ActiveAdmin.register Address do
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
    column :type do |addr|
      addr.type == "BillingAddress" ? "Billing" : "Shipping"
    end

    unless GlobalConstants::BLOCK_ADMIN_USERS
      actions
    end
  end

  show do |address|
    panel "Address Details" do
      attributes_table_for address do
        address.attributes.keys.each do |attribute|
          if attribute.downcase == 'subscription_id'
            row attribute.to_sym do
              subscription = address.subscriptions.last
              link_to subscription.id, admin_subscription_path(subscription)
            end
          else
            row attribute.to_sym
          end
        end
      end
    end

    panel "Address Change Logs" do
      table_for address.versions do
        column("") do |v|
          link_to 'view', admin_paper_trail_version_path(v)
        end
        column("Date") {|v| v.created_at}
        column :event
        column("Changed By") {|v| v.whodunnit}
      end
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
      @address_changer = case resource.type
        when 'ShippingAddress' then ShippingAddress::Changer.new(resource, @subscription, permitted_params[:address])
        when 'BillingAddress' then BillingAddress::Changer.new(resource, @subscription, permitted_params[:address])
        else raise "Address invalid - Type not set as Billing or Shipping"
        end

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
        redirect_to admin_address_path(resource)
      end
    end
  end

  permit_params :first_name, :last_name, :line_1, :line_2, :city, :state, :zip, :country

end

