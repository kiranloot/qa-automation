require_relative "preceed_experiment"
if ENV['RUN_ASPECTOR_EXAMPLE']
t = PreceedTest.new
t.first_try
t.second_try
end