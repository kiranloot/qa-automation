class AmiiboController < ApplicationController
  def index
    @stock_remains = stock_remaining_amiibo?
  end
end
