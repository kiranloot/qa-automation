require 'fastly'
require_relative 'box_object'

class FastlyAPI
  def initialize(box = Box.new(ENV['SITE']))
    @api_key = 'a40c0d290e94d507197892ff2e1e0743'
    @fastly = Fastly.new(api_key: @api_key)
    @service = Fastly::Service.new( {id: box.fastly_id }, @fastly )
  end

  def purge_cache
    @service.purge_all
  end 
end
