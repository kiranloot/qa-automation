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
end 
