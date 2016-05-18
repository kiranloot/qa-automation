require 'net/http'
require 'json'
require 'yaml'

class LogMonitor
  def initialize
    file_data = YAML.load(File.open(ENV['SERVER_CONFIGS']))[ENV['SITE']]
    @logentries_key = file_data['logentries_key']
    @logentries_log_set = file_data['logentries_log_set']
    @logentries_log_name = file_data['logentries_log_name']
    @get_string = "https://pull.logentries.com/#{@logentries_key}/hosts/#{@logentries_log_set}/#{@logentries_log_name}"
  end

  def get_errors_log(starttime, endtime)
    response = Net::HTTP.get(URI("#{@get_string}/?start=#{starttime}&end=#{endtime}&filter=/(fail|error)/i&format=json"))
    File::open("reports/lastrun_logentries#{ENV['TEST_ENV_NUMBER']}.json", 'w') {
      |f| f.write("\n#{response}")
    }
  end
end
