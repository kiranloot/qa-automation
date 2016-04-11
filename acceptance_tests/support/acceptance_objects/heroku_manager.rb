module HerokuManager
  require 'heroku-api'
  require 'yaml'
  include RSpec::Matchers

  @key = YAML.load(File.open(ENV['HEROKU_KEY']))['key']
  @heroku = Heroku::API.new(:api_key => @key)
  @app = YAML.load(File.open(ENV['SERVER_CONFIGS']))[ENV['SITE']]['app']

  def self.verify_dyno_count(count)
    dyno_count = 0
    resp = @heroku.get_ps(@app)
    resp.body.each do |d|
      dyno_count += 1 if (d['process'].include?('web'))
    end
    expect(count).to eq(dyno_count)
  end

  def self.scale_web_dynos(count)
    @heroku.post_ps_scale(@app, 'web', count)
    verify_dyno_count(count)
  end
end
