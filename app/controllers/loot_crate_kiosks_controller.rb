class LootCrateKiosksController < ApplicationController
  # This action sets the newsletter cookie so that it
  # ensures the newsletter signup modal does not appear
  def show
    cookies['wf-newsletter'] = true
    redirect_to root_path
  end
end
