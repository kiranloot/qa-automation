ActiveAdmin.register StoreCredit do
  menu parent: "More", :if => proc{ !GlobalConstants::BLOCK_ADMIN_USERS }
  
  index  do
    column :id
    column :referrer_user_id do |sc|
      link_to sc.referrer_user_id, admin_user_path(sc)
    end
    column :referrer_user_email
    column :referred_user_id
    column :referred_user_email
    column :status
    column :amount

    unless GlobalConstants::BLOCK_ADMIN_USERS
      column "Actions" do |resource|
        links = ''.html_safe
        links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link show_link"
        links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
        links
      end
    end
  end

  show do
    if store_credit.friendbuy_conversion_id
      @friendbuy_conversion_details = Friendbuy::API.new.get_conversion(store_credit.friendbuy_conversion_id)
    else
      @friendbuy_conversion_details = nil
    end

    panel "Store Credit Details" do
      attributes_table_for store_credit do
        row("ID") { store_credit.id }
        row("Amount") { store_credit.amount }
        row("Referrer ID") { link_to store_credit.referrer_user_id, admin_user_path(store_credit.referrer_user_id) }
        row("Referrer Email") { store_credit.referrer_user_email }
        row("Referred User ID") { link_to store_credit.referred_user_id, admin_user_path(store_credit.referred_user_id) }
        row("Referred User Email") { store_credit.referred_user_email }
        row("Status") { store_credit.status }
        row("Friendbuy Conversion ID") { store_credit.friendbuy_conversion_id }
      end
    end
    # HACK should somehow be in a partial
    if @friendbuy_conversion_details
      panel "Friendbuy Conversion Details" do
        attributes_table_for @friendbuy_conversion_details do
          if @friendbuy_conversion_details["purchases"]
            row("purchase order id") { @friendbuy_conversion_details["purchase"]["order_id"] }
            row("purchase order total") { @friendbuy_conversion_details["purchase"]["total"] }
            row("purchase order email") { @friendbuy_conversion_details["purchase"]["email"] }
          end
        end
      end
    end
  end

  permit_params [:amount, :reason , :referrer_user_email, :referred_user_email, :status]
end
