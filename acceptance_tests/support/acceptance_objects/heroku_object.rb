require 'net/http'

class HerokuAPI
  def initialize
    @apikey = '56d6a4d5-724e-4a94-b427-0a86263b2e0e'
    @heroku = PlatformAPI.connect_oauth(@apikey)
  end

  def create_user_with_active_sub
    dyno = run_command("rake create_test_users:with_one_active_subscription")
    email = parse_dyno_log_for_email(dyno)
    return email
  end

  def create_user_with_canceled_sub
    dyno = run_command("rake create_test_users:with_one_canceled_subscription")
    email = parse_dyno_log_for_email(dyno)
    return email
  end

  def run_command(command) 
    output = @heroku.dyno.create($app, {"command" => command, "attach" => "false"})
    return output
  end

  def parse_dyno_log_for_email(dyno)
    for i in 0..30
      sleep (2)
      if is_dyno_done?(dyno['name'])
        log = get_dyno_log(dyno)
        break
      end
    end
    puts log
    email = log[/Email: (.*)/,1]
    return email
  end

  def is_dyno_done?(dyno_name)
    dyno_list = @heroku.dyno.list($app)
    for i in 0...dyno_list.length
      if dyno_list[i]['name'] == dyno_name
        return false
      end
    end
    return true
  end

  def get_dyno_log(dyno)
    log_session = @heroku.log_session.create($app, {
      "dyno" => dyno["name"],
      "lines" => 50, 
      "source" => "app",
      "tail" => "false"})
    uri = URI(log_session["logplex_url"])
    log = Net::HTTP.get(uri)
    return log
  end
end
