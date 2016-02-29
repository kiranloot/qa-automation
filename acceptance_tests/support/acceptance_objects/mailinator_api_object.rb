require 'mailinator'

class MailinatorAPI
  def initialize
    @api_key = '6f138ae31e8d48cd9c41d61f2150307c'
    Mailinator.configure do |config|
      config.token = @api_key
    end
  end

  def get_email_subject_lines_from_inbox(email_address)
    subjects = []
    inbox = Mailinator::Inbox.get(email_address)
    inbox.messages.each do |email|
      subjects << email.subject
    end
    return subjects
  end

  def download_first_email(email_address)
    inbox = Mailinator::Inbox.get(email_address)
    message = nil
    5.times do
      message = inbox.messages.first
      unless message.nil?
        break
      end
      sleep(1)
    end
    return message.download
  end
end
