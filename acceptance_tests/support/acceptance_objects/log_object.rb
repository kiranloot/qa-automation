require 'net/http'
require 'json'

class LogMonitor
  include RSpec::Matchers
  def initialize(box)
    @get_string = "https://pull.logentries.com/#{box.logentries_key}/hosts/#{box.logentries_log_set}/#{box.logentries_log_name}"
  end

  def get_errors_log(starttime, endtime)
    response = Net::HTTP.get(URI("#{@get_string}/?start=#{starttime}&end=#{endtime}&filter=/error/i&format=json"))
    File::open("reports/lastrun_logentries#{ENV['TEST_ENV_NUMBER']}.json", 'a') {
      |f| f.write("\n#{response}")
    }
  end
end
