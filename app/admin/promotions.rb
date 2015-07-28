ActiveAdmin.register Promotion do
  menu :priority => 5
  config.batch_actions = false
  filter :coupons_code_cont, label: 'Coupon Code'
  filter :starts_at
  filter :ends_at
  filter :name
  filter :description
  filter :created_at
  filter :adjustment_amount
  filter :adjustment_type
  filter :trigger_event
  filter :conversion_limit
  filter :one_time_use

  # CONTROLLER ACTIONS
  controller do
    before_filter :clean_up_trigger_event, only: [:create, :update]
    before_filter :allow_nil_end_date, only: [:create, :update]
    before_filter :sort, only: :coupons

    def new
      @promotion = Promotion.new
      @page_title = 'New Promotion'
      @plans     = Plan.all

      render :new, layout: 'active_admin'
    end

    def edit
      @promotion = Promotion.find(params[:id])
      @plans     = Plan.all
      @page_title = 'Edit Promotion'

      render :edit, layout: 'active_admin'
    end

    def create
      @promotion = Promotion.new(permitted_params[:promotion])
      @create_promotion_with_associations = CreatePromotionWithRecurlyCoupon.new(@promotion, eligible_plans)
      @create_promotion_with_associations.perform

      if @create_promotion_with_associations.errors.empty?
        if @promotion.one_time_use
          create_single_use_coupons
        else
          create_multi_use_coupon
        end

        redirect_to admin_promotion_path(@promotion)
      else
        flash.now[:error] = @create_promotion_with_associations.errors.full_messages.to_sentence
        @promotion.eligible_plan_ids = eligible_plan_ids
        @plans = Plan.all
        @page_title = 'New Promotion'
        render :new, layout: 'active_admin'
      end
    end

    def update
      @promotion = Promotion.find(params[:id])
      @promotion.assign_attributes(allowed_update_params)

      if @promotion.valid?
        @promotion.save!
        @promotion.eligible_plans = eligible_plans
        create_single_use_coupons if @promotion.one_time_use && coupon_quantity > 0 && coupon_code_length > 0
        redirect_to admin_promotion_path(@promotion)
      else
        flash.now[:error] = @promotion.errors.full_messages.to_sentence
        @plans     = Plan.all
        @page_title = 'Edit Promotion'
        render :edit, layout: 'active_admin'
      end
    end

    private

      def create_single_use_coupons
        PromoCodeWorker.perform_async(@promotion.id,
                                      coupon_generation_builder.recipients,
                                      coupon_generation_builder.coupon_prefix,
                                      coupon_generation_builder.length,
                                      coupon_generation_builder.quantity
                                     )
      end

      def create_multi_use_coupon
        PromoCodeWorker.multiuse(@promotion, coupon_generation_builder.coupon_prefix)
      end

      def coupon_generation_builder
        params.merge!(coupon_prefix: @promotion.coupon_prefix, admin_email: current_admin_user.email)
        CouponGenerationBuilder.new(params)
      end

      def clean_up_trigger_event
        params[:promotion][:trigger_event] = params[:promotion][:trigger_event].reject(&:empty?).join(' ')
      end

      # TODO: Remove this hack. Should be handled elsewhere.
      def allow_nil_end_date
        unless params[:promotion][:ends_at].presence
          params[:promotion][:ends_at] = "2200-01-01"
        end
      end

      def sort
        @order_option = params[:order] =~ /^([\w\_\.]+)_(desc|asc)$/ ? [$1, $2].compact.join(' ') : :id
      end

      def allowed_update_params
        permitted_params[:promotion].except(:name, :one_time_use, :adjustment_amount, :adjustment_type, :coupon_prefix)
      end

      def eligible_plan_ids
        @eligible_plan_ids ||= (params[:promotion][:eligible_plan_ids] || []).reject(&:blank?).uniq
      end

      def eligible_plans
        Plan.find eligible_plan_ids
      end

      def coupon_quantity
        (params[:quantity] || '0').to_i
      end

      def coupon_code_length
        (params[:char_length] || '0').to_i
      end
  end

  index do
    column "Starts", :starts_at
    column "Ends", :ends_at
    column :name
    column :description
    column "Single Use?", :one_time_use
    column "Type", :adjustment_type
    column "Amount", :adjustment_amount

    actions defaults: true do |promotion|
      link_to 'Coupons', coupons_admin_promotion_path(promotion)
    end
  end

  member_action :coupons, method: :get do
    promotion = Promotion.includes(:coupons).find(params[:id])

    @coupons = promotion.coupons.page(params[:coupon_page]).per(20).order(@order_option)
  end

  member_action :create_coupons, method: :post do
    @promotion = Promotion.find(params[:id])

    create_single_use_coupons

    flash[:success] = 'Successfully queued coupons creation.'
    redirect_to :back
  end

  member_action :new_coupons, method: :get do
    @promotion = Promotion.find(params[:id])
  end

  member_action :export_coupons, method: :get do
    @promotion = Promotion.includes(:coupons).find(params[:id])

    csv = CSV.generate do |csv|
      csv << %w[CODE STATUS USAGE]

      @promotion.coupons.each do |coupon|
        csv << [coupon.code, coupon.status, coupon.usage_count]
      end
    end

    send_data csv.encode('Windows-1251'), type: 'text/csv; charset=windows-1251; header=present', disposition: "attachment; filename=#{@promotion.name}.csv"
  end

  collection_action :check_code_availability, method: :post do
    coupon_prefix = params[:coupon_prefix].try(:downcase)
    case
      when coupon_prefix.blank?
        render json: { error: 'Missing param :coupon_prefix. Please notify a developer' }
      when Promotion.find_by_coupon_prefix(coupon_prefix)
        render json: { error: "Coupon prefix '#{ coupon_prefix }' is taken." }
      else
        render json: {success: true}
    end
  end

  collection_action :import, method: :get do
  end

  collection_action :import_promotions, method: :post do
    importer = PromotionImporter.new(params[:file])

    importer.import_promotions

    flash[:success] = "Promotions created."
    redirect_to :back
  end

  action_item(:export, only: :coupons) do
    link_to 'Export', export_coupons_admin_promotion_path(resource, format: :csv)
  end

  action_item(:create_coupons, only: :coupons) do
    link_to 'Create Coupons', new_coupons_admin_promotion_path(resource)
  end

  action_item(:import, only: :index) do
    link_to 'Import', import_admin_promotions_path
  end

  # END CONTROLLER ACTIONS

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
    f.input :starts_at, as: :datepicker
    f.input :ends_at, as: :datepicker
    f.input :description
    f.input :name
    f.input :one_time_use
    f.input :adjustment_amount
    f.input :adjustment_type
    f.input :conversion_limit
    end
  end

  permit_params :starts_at, :ends_at, :description, :name, :one_time_use, :adjustment_amount, :adjustment_type,
                :conversion_limit, :coupon_prefix, :trigger_event
end
