module UserHelper
  def zendesk_ticket_link(ticket_id)
    ticket_url = ENV['ZENDESK_API_URL'].sub('api/v2', 'agent/tickets')

    link_to t('helpers.view'), "#{ticket_url}/#{ticket_id}", target: '_blank'
  end
end
