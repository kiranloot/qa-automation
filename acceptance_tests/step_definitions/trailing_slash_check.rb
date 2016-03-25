#WHENS


When /the user adds a slash at the end of the URL$/ do
	$test.current_page.append_slash
end 

#THENS

Then /the page should redirect to the URL with no trailing slash$/ do
	$test.current_page.redirect_no_trailing_slash?
end


	