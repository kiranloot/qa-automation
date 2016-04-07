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

  def download_first_email(email_address, attempts = 10)
    message = nil
    attempts.times do
      message = Mailinator::Inbox.get(email_address).messages.first
      unless message.nil?
        break
      end
      sleep(1)
    end
    Capybara::Node::Simple.new(message.download.body_html)
  end

  def email_in_inbox?(email, expected_subjects)
    expected_subjects.each do |subject|
      if get_email_subject_lines_from_inbox(email).include? subject
        return true
      end
    end
    return false
  end

  def verify_email(type,email)
    valid_subject_lines = YAML.load(File.open('acceptance_tests/support/email_data.yml'))[type]['subject_lines']
    email_pass = false
    10.times do
      if email_in_inbox?(email, valid_subject_lines)
        email_pass = true
        break
      else
        sleep(3)
      end
    end
    expect(email_pass).to be_truthy,
      """
        Did not find an email with subject line(s) '#{valid_subject_lines}' for email #{email}
      """
  end
end
