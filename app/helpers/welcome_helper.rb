module WelcomeHelper
  def plan_boxes_by_country(country)
    plans = PlanFinder.by_country(country).order(:period)
    boxes = ''

    plans.each do |plan|
      boxes += render partial: 'welcome/plan_box', locals: { plan: plan }
    end

    boxes.html_safe
  end
end
