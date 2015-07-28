class NewsletterSignupsController < ApplicationController
  respond_to :js

  def create
    user = OpenStruct.new(email: params[:email])
    @result = Sailthru::ListManager.new(user).subscribe_new_email || {'error'=> 'Newsletter signup issue'}

    respond_to do |format|
      unless @result["error"].present?
        format.json { render json: @result, status: :ok }
        format.html
      else
        format.json { render json: @result, status: :unprocessable_entity }
        format.html
      end
    end
  end
end
