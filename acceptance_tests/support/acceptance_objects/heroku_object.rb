require 'net/http'
require 'platform-api'
require_relative 'box_object'

class HerokuAPI
  require 'yaml'
  attr_accessor :app, :heroku

  def initialize(box = Box.new(ENV['SITE']))
    @apikey = '56d6a4d5-724e-4a94-b427-0a86263b2e0e'
    @heroku = PlatformAPI.connect_oauth(@apikey)
    #@page_configs = YAML.load(File.open("acceptance_tests/support/acceptance_objects/page_configs.yml"))
    #@env = ENV['SITE']
    @app = box.app
  end

  def create_user_with_active_sub
    dyno = run_command("rake create_test_users:with_one_active_subscription")
    parse_dyno_log_for_email(dyno)
  end

  def create_user_with_canceled_sub
    dyno = run_command("rake create_test_users:with_one_canceled_subscription")
    parse_dyno_log_for_email(dyno)
  end

  def create_user_with_acive_sub_and_tracking_info
    dyno = run_command("rake create_test_users:with_one_active_subscription_with_tracking")
    parse_dyno_log_for_email(dyno)
  end

  def clear_rails_cache
    run_command("rake tmp:clear")
  end

  def run_command(command)
    @heroku.dyno.create(@app, {"command" => command, "attach" => "false"})
  end

  def parse_dyno_log_for_email(dyno)
    for i in 0..60
      sleep (2)
      if is_dyno_done?(dyno['name'])
        log = get_dyno_log(dyno)
        break
      end
    end
    puts "log:"
    puts log
    log[/Email: (.*)/,1]
  end

  def is_dyno_done?(dyno_name)
    dyno_list = @heroku.dyno.list(@app)
    for i in 0...dyno_list.length
      if dyno_list[i]['name'] == dyno_name
        return false
      end
    end
    return true
  end

  def get_dyno_log(dyno)
    log_session = @heroku.log_session.create(@app, {
      "dyno" => dyno["name"],
      "lines" => 500,
      "source" => "app",
      "tail" => "false"})
    uri = URI(log_session["logplex_url"])
    Net::HTTP.get(uri)
  end
end
