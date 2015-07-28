require 'spec_helper'

describe MediaInquiriesController do
  describe 'GET #new' do
    it 'returns success' do
      get :new
      expect(response).to be_success
    end
  end
end
