module Wombat
  class Pusher
    def self.push(payload)
      if ['development', 'test'].include? Rails.env
        Rails.logger.info "wombat payload: #{payload}"
      end

      return true if Rails.env == 'test'

      begin
        response = Wombat::Client.push(payload)
        puts response
        return true
      rescue => e
        if response.nil? # Wombat::Client does not return a response if there is an issue
          Rails.logger.error "Wombat push response: #{e}"
        else
          Rails.logger.error "wombat push response: #{response.body} #{response.code} #{response.message}
            #{response.headers.inspect}"
        end
        return false
      end
    end
  end
end
