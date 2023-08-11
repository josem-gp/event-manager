require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe '#google_oauth2' do
    context 'when user is successfully authenticated' do
      before do
        allow(controller).to receive(:sign_out_all_scopes)
        setup_mock_omniauth_valid_credentials
      end

      it 'signs out all scopes' do
        expect(controller).to have_received(:sign_out_all_scopes)
      end

      it 'sets a flash notice' do
        expect(flash[:notice]).to eq(I18n.t('devise.omniauth_callbacks.success', kind: 'Google'))
      end

      it 'signs in and redirects the user' do
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user authentication fails' do
      before do
        setup_mock_omniauth_invalid_credentials
      end

      after do
        reset_mock_omniauth
      end

      it 'sets a flash error' do
        expect(flash[:error]).to eq(I18n.t('devise.omniauth_callbacks.failure', kind: 'Google',
                                                                                reason: 'Authentication failed.'))
      end

      it 'redirects to the new_user_sessions_path' do
        expect(response).to redirect_to(new_user_registration_path)
      end
    end
  end
end
