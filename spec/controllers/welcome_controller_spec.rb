require 'spec_helper'

describe WelcomeController do
  describe 'behavior of setting the locale on every request' do
    context 'country cookie unset' do
      before do
        I18n.locale = :de
        request.cookies[:country] = nil
        get :international
      end

      it 'sets the default locale' do
        expect(I18n.locale).to eq :en
      end
    end

    context 'country cookie set' do
      before do
        I18n.locale = :en
        request.cookies[:country] = 'DE'
        get :international
      end

      it 'sets the locale to the value related to the cookie' do
        expect(I18n.locale).to eq :de
      end
    end
  end
end
