# http://stackoverflow.com/questions/6115589/geocoder-how-to-test-locally-when-ip-is-127-0-0-1
# lib/spoof_ip.rb

class SpoofIp
  def initialize(app, ip)
    @app = app
    @ip = ip
  end

  def call(env)
    env['REMOTE_ADDR'] = env['action_dispatch.remote_ip'] = @ip
    @status, @headers, @response = @app.call(env)
    [@status, @headers, @response]
  end
end
