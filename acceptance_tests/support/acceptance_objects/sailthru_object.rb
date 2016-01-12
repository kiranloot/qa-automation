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

  def email_has_sub_status?(email, type, sub_status, attempts = 15)

    #Establish which key to look for based on data passed from step def
    sub_status_key = 'subscription_status'
    case type
    when 'Anime'
      sub_status_key = 'an_subscription_status'
    when 'Pets'
      sub_status_key = 'pt_subscription_status'
    when 'Level Up'
      sub_status_key = 'lu_subscription_status'
    when ''
    else
      puts 'Unknown value. Checking default for test'
    end


    attempts.times do
      response = get_user(email)
      if response['vars'][sub_status_key] == sub_status
        return true
      else
        sleep(2)
      end
    end
    return false
  end

end
