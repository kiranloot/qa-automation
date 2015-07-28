class SoldOutController < ApplicationController
  def index
    redirect_to '/join' if false == GlobalConstants::SOLDOUT # no one is allowed here if we're not in SOLDOUT mode
  end
end
