require 'sailthru'

class SailthruAPI
  def initialize
    api_key = '1c9ba94859c98db46ef2b7ce855d8d87'
    api_secret = 'aabf070535fe99723f26afdab31c3c61'
    api_url = 'https://api.sailthru.com'
    @sailthru = Sailthru::Client.new(api_key, api_secret, api_url)
  end

  def get_user(email)
    fields = {'vars' => 1, 'lists' => 1}
    data = {
      'id' => email,
      'key' => 'email',
      'fields' => fields
    }
    @sailthru.api_get('user',data)
  end

  def email_in_list?(email, list, attempts = 15)
    attempts.times do
      response = get_user(email)
      if response['lists'].keys.include?(list)
        return true
      else
        sleep(1)
      end
    end
    return false
  end

  def email_has_sub_status?(email, sub_status, attempts = 15)
    attempts.times do
      response = get_user(email)
      if response['vars']['subscription_status'] == sub_status
        return true
      else
        sleep(2)
      end
    end
    return false
  end
end
