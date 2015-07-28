class ProductPresenter < SimpleDelegator
  def initialize(product, template)
    super(product)
    @template = template
  end

  def self.from_product_list(*products)
    products.flatten.map { |product| ProductPresenter.new(product)  }
  end

  def stocks_status
    in_stock_variants.size > 0 ? "" : "soldout"
  end

  def main_image
    h.image_tag("levelup/#{sku}.jpg", class: 'img-responsive hidden-xs')
  end

  def icon_image
    h.image_tag("levelup/#{sku}-icons.png", class: 'img-responsive')
  end

  def default_plan_monthly_cost
    h.number_to_currency default_plan.monthly_cost, locale: :en
  end

  def default_plan_total_cost
    return unless product_in_stock?

    total_cost = h.number_to_currency default_plan.cost, locale: :en
    h.content_tag(:p, "Total: #{total_cost}", class: 'total-cost') + h.content_tag(:p, 'Recurring subscription plan')
  end

  def variant_options
    return unless product_in_stock?

    variants_html = variants_option_from_collection
    sizing_html   = product_has_one_variant? ? '' : h.render('level_up/plans/sizing_chart')

    variants_html + sizing_html
  end

  def plan_options
    return unless product_in_stock?

    html_attributes = {id: sku, class: 'select select2 select2-offscreen subSelect'}
    h.select_tag 'plans', h.options_from_collection_for_select(plans_ordered_by_period, :name, :readable_title, selected: default_plan.name), html_attributes
  end

  def checkout_link
    return soldout_text unless product_in_stock?

    html_attributes       = {class: 'btn btn-secondary select-plan', role: 'button'}
    default_params        = {plan: default_plan.name}
    default_variant_param = {variant_name: default_variant.name, variant_id: default_variant.id}
    default_params.merge!(default_variant_param) if product_has_one_variant?

    h.link_to 'SUBSCRIBE', h.new_level_up_checkout_path(default_params), html_attributes
  end

  def notes
    case sku
    when 'wearable-crate'
      "NOTE: This month's shirt will be a unisex cut. We will have mens and womens sizing options available for future months. Please keep an eye on your inbox for details!"
    end
  end

  private
    def variants_option_from_collection
      if product_has_one_variant?
        html_attributes         = {class: 'select variant-options hide'}
        h.select_tag 'variants', h.options_from_collection_for_select(variants_ordered_by_size, 'id', 'name', disabled: out_of_stock_variants), html_attributes
      else
        html_attributes         = {class: 'select variant-options'}
        h.select_tag 'variants', h.content_tag(:option,'SHIRT SIZE', value: "") + h.options_from_collection_for_select(variants_ordered_by_size, 'id', 'name', disabled: out_of_stock_variants), html_attributes
      end
    end

    def plans_ordered_by_period
      plans.sort_by { |plan| plan.period }
    end

    def variants_ordered_by_size
      variants.order(created_at: :asc)
    end

    def product_has_one_variant?
      variants.size == 1
    end

    def default_variant
      in_stock_variants.first || NullVariant.new
    end

    def in_stock_variants
      variants.select { |v| v.in_stock? }
    end

    def product_in_stock?
      in_stock_variants.size > 0
    end

    def h
      @template
    end

    def soldout_text
      h.content_tag(:h3, 'SOLD OUT')
    end

    def out_of_stock_variants
      variants.map { |v| v.id unless v.in_stock? }.compact
    end
end
