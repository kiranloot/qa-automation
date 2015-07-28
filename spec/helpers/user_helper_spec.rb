require 'spec_helper'

describe UserHelper do
  describe "#zendesk_ticket_link(id)" do
    it "returns link to a zendesk ticket" do
      url = ENV['ZENDESK_API_URL'].sub('api/v2', 'agent/tickets')

      zendesk_link = helper.link_to('view', "#{url}/1", target: "_blank")

      expect(helper.zendesk_ticket_link(1)).to eq zendesk_link
    end
  end
end