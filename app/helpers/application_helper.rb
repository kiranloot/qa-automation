module ApplicationHelper
  include Carmen

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def international?(country = nil)
    country ||= cookies[:country]
    if country.blank? || country == 'US'
      false
    else
      Country.coded(country) ? true : false
    end
  end

  def learnmore_international_filter
    html = international? ? 'international' : 'us'

    html.html_safe
  end

  def supported_international? # maybe not needed after adding multi-month subs for international
    ['AU', 'CA', 'DE', 'DK', 'FI', 'FR', 'GB', 'IE', 'NL', 'NO', 'NZ', 'SE'].include?(cookies[:country])
  end

  def get_region
    cookies[:country]
  end

  def shipping_cost
    Settings.shipping_cost.to_f
  end

  def tax
    Settings.tax.to_f
  end

  def show_countdown_timer?
    GlobalConstants::SHOWCOUNTDOWN && ('welcome' == controller_name || 'subscriptions' == controller_name)
  end

  def current_link_class(page)
    'active' if params[:controller] == page
  end

  def page_id
    if id = content_for(:body_id) and id.present?
      return id
    else
      base = controller.class.to_s.gsub("Controller", '').underscore.gsub("/", '_')
      return "#{base}-#{controller.action_name}"
    end
  end

  def should_block_for_subscription?(sub)
    sub.recurly_subscription_id.nil?
  end

  def should_block_for_user?(user)
    user.subscriptions.each { |sub| return true if sub.recurly_subscription_id.nil? }
    false
  end

  def controller_name_for_id
    controller_path.gsub('/', '-')
  end


  def get_month
    # The month changes at 00:00 on the 20th Eastern Time, (DST is adjusted for automatically)
    t = Time.now.in_time_zone('US/Eastern')
    t += 1.month if (20 <= t.mday) # beginning on the 20th, use the next month's name
    t.strftime('%B')
  end

  def set_code
    code = 'SAVE3'

    # Used for Special promo 20141107
    # the uri entered here has been manually downcased.
    # people get here by going to lootcrate.com/halo
    if request.fullpath.downcase == '/?utm_source=unpaid&utm_medium=social&utm_campaign=halo'
      code = 'HALO'
    end

    # used to alter the Hello Bar for amiibo funnel
    if ('/amiibo' == request.fullpath.downcase[0..6]) || (defined?(plan) && !plan.nil? && plan.is_amiibo?) || (defined?(plan) && !plan.nil? && plan.is_amiibo?)
      hello_amiibo = true
      link_page = '/amiibo'
    else
      hello_amiibo = false
      link_page = '/join'
    end
  end
end
