require 'mailinator'

class MailinatorAPI
  include RSpec::Matchers
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
    return Capybara::Node::Simple.new(message.download.body_html)
  end

  def verify_email(type,email)
    email_data = YAML.load(File.open('acceptance_tests/support/email_data.yml'))
    target_content = email_data[type]['subject_line']
    target_content_new = email_data[type]['subject_line2']
    email_pass = nil
    subjects = []
    5.times do
      subjects = get_email_subject_lines_from_inbox(email)
      if subjects.include? target_content
        email_pass = true
      elsif subjects.include? target_content_new
        email_pass = true
      else
        email_pass = false
        sleep(3)
      end
    end
    expect(email_pass).to be_truthy,
      """
        Did not find an email with subject line '#{target_content}' for email #{email}
        Subject lines found: #{subjects}
     """
  end
end
