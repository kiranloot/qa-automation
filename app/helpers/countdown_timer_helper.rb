module CountdownTimerHelper
  def redirect_countdown
    GlobalConstants::SOLDOUT ? '/soldout' : '/join'
  end

  def show_countdown_timer
    GlobalConstants::SHOWCOUNTDOWN
  end

  def is_soldout
    GlobalConstants::SOLDOUT
  end
end
