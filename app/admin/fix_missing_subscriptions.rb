ActiveAdmin.register_page "Fix Missing Subscriptions" do
  menu parent: "More", :if => proc{ !GlobalConstants::BLOCK_ADMIN_USERS }

  content do
    unless GlobalConstants::BLOCK_ADMIN_USERS
      render 'import_form'
    end
  end
end
