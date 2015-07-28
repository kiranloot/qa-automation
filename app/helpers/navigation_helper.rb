module NavigationHelper
  def show_continue_shopping?
    if current_page?('/users/sign_up') || current_page?('/users/login') || current_page?('/subscriptions/new')
      true
    else
      false
    end
  end

  def show_progress_bar?
    if current_page?('/users/sign_up') || current_page?('/users/login') || current_page?('/subscriptions/new') || current_page?('/subscriptions')
      true
    else
      false
    end
  end

  def show_account_navbar?
    if current_page?('/user_accounts') || current_page?('/user_accounts/subscriptions') || current_page?('/user_accounts/store_credits')
      true
    else
      false
    end
  end

  def get_progress_step
    if current_page? '/subscriptions'
      step = 1
    end

    if current_page?('/users/sign_up') || current_page?('/users/login')
      step = 2
    end

    if current_page? '/subscriptions/new'
      step = 3
    end

    step
  end

  def show_news_letter?
    if current_page?('/subscriptions/new') || current_page?('/join') || current_page?('/subscriptions') || params[:controller] == 'checkouts'
      false
    else
      true
    end
  end

  def show_quote_bar?
    if current_page?('/user_accounts') || current_page?('/user_accounts/subscriptions') || current_page?('/user_accounts/store_credits')
      false
    else
      true
    end
  end

  def is_levelup?
    if current_page_levelup? || /level_up/.match(request.referrer)
      true
    else
      false
    end
  end 

  # Path helper that determines path based on product (Product family)
  def join_plan_helper_path(country)
    if current_page_levelup?
      level_up_path(country)
    else
      join_path(country)
    end
  end

  private
  def current_page_levelup?
    request.original_fullpath.include? 'level_up'
  end

end
