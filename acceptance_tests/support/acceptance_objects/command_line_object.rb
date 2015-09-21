require 'open3'

class CommandLine
  def initialize
  end

  def run_command(cmd)
    stdout,stderr,status = Open3.capture3(cmd)
    while (!status.successful?)
      puts "stdout:"
      pust stdout
      puts "stderr:"
      puts stderr
      pust "status:"
      puts status
    end
    return stdout
  end

  def run_heroku_rake(rake,app)
    run_command("heroku run rake #{rake} --app #{app}")
  end

  def create_user_with_subscription_tracking_information
    parse_ouput_for_email(run_heroku_rake("create_test_users:with_one_active_subscription_with_tracking","lootcrate-qa2"))
  end

  def parse_output_for_email(output)
    ouput[/Email: (.*)/,1]
  end

end
