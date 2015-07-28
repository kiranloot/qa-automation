ActiveAdmin.register Coupon do
  actions :all, except: [:new, :create, :destroy]
  remove_filter :promotion

  index do
    column :id
    column :code
    column :created_at
    column :updated_at
    column :status
    column :usage_count
    column :archived_at
    column 'One Time Use' do |coupon|
      coupon.one_time_use
    end

    column('Actions') do |coupon|
      link_to('archive', archive_admin_coupon_path(coupon), method: :put) if coupon.status == 'Active'
    end
    actions
  end

  member_action :archive, method: :put do
    @coupon = Coupon.find(params[:id])

    @coupon.archive!

    if @coupon.errors.any?
      flash[:error] = @coupon.errors.full_messages.to_sentence
      redirect_to :back
    else
      flash[:success] = 'Successfully archived coupon.'
      redirect_to :back
    end
  end

  permit_params [:promotion_id, :code, :status, 'archived_at(1i)', 'archived_at(2i)', 'archived_at(3i)', 'archived_at(4i)', 'archived_at(5i)']
end
