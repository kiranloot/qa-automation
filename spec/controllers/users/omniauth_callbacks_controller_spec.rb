require 'spec_helper'

describe Users::OmniauthCallbacksController do
  include Devise::TestHelpers
  
  before(:each) do
    stub_facebook_env_for_omniauth
  end

  it 'should GET facebook' do
    get :facebook

    expect(flash[:notice]).to eq('Successfully authenticated from Facebook account.')
  end

  def stub_facebook_env_for_omniauth
    request.env['devise.mapping'] = Devise.mappings[:user]
    facebook_response = {
      provider: 'facebook',
      uid: '123545',
      info: {
        first_name: 'User',
        last_name:  'Test',
        email:      'test@example.com',
        urls: {
          'Facebook' => 'http://facebook.com/user'
        }
      },
      credentials: {
        token: '123456',
        expires_at: Time.now + 1.week
      },
      extra: {
        raw_info: {
          gender: 'male'
        }
      }
    }
    request.env['omniauth.auth'] = OmniAuth::AuthHash.new(facebook_response)
  end
end