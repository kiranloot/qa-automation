module PaymentCompletedHelper
  def referred_by_pandora?
    cookies['pandora_utm'].present?
  end

  def pandora_pixel
    keys = { aid: utm_json['aid'], cid: utm_json['cid'] }

    src_url = "http://stats.pandora.com/tracking/#{Random.rand(10000000000000000)}/type::ad_tracking_pixel/ctype::lootcrate/etype::signup/aid::#{keys[:aid]}/cid::#{keys[:cid]}"

    image_tag(src_url, height: '1', width: '1')
  end

  private
    def utm_json
      JSON.parse(cookies['pandora_utm'])
    end
end