class ReviewController < ApplicationController
	# To acquire these links:
	#  Survey Gizmo -> log in -> Looter Satisfaction Surveys -> (click on the survey) ->
	#    Share tab -> Link will be displayed in a box near the top of the page
	def index
		@monthly_link = "https://www.surveygizmo.com/s3/2204638/CYBER-2015-Looter-Satisfaction-Survey"

		
		@monthly_link_with_domain_included = "#{@monthly_link}?__ref=#{request.original_url}"
	end
end
