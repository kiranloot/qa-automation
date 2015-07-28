ActiveAdmin.register AdminUser do
  menu :priority => 2, :if => proc{ current_admin_user.is_super_admin?}

  #prevent access to this section by non super-admins. TODO: allow partial access to EDIT, (so they can change their own password, but would need to prevent them from changing email)
  controller do
    before_filter :super_admins_only

    private

    def super_admins_only
      unless current_admin_user.is_super_admin?
        redirect_to admin_dashboard_path
      end
    end
  end

  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    actions
  end

  filter :email, filters: ['equals', 'contains', 'starts_with', 'ends_with']

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
