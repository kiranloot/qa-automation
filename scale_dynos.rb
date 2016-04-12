require 'platform-api'
require 'yaml'

ENV['HEROKU_KEY'] ||= "#{ENV['HOME']}/heroku_key.yml"
ENV['SERVER_CONFIGS'] ||= "#{ENV['HOME']}/server_configs.yml"
ENV['SITE'] ||= "qa"
ENV['DYNO_COUNT'] ||= "1"

@site = ARGV[0] ? ARGV[0] : ENV['SITE']
@dyno_count = ARGV[1] ? ARGV[1] : ENV['DYNO_COUNT']

@heroku = PlatformAPI.connect_oauth(YAML.load(File.open(ENV['HEROKU_KEY']))['key'])
@app = YAML.load(File.open(ENV['SERVER_CONFIGS']))[@site]['app']

def scale_web_dynos(count)
  @heroku.formation.update(@app, 'web', {'quantity' => count})
  new_count = @heroku.formation.info(@app, 'web')['quantity']
  if count != new_count
    raise 'Heroku dynos not scaled as specified'
  end
end

scale_web_dynos(@dyno_count.to_i)
puts "Web dyno count for '#{@app}' set to #{@dyno_count}."
