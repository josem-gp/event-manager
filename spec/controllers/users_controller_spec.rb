require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET #edit' do
    before do
      get :edit, params: { id: user.id }
    end

    it 'renders the edit template' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the user and redirects to root_path' do
        new_attributes = { first_name: 'New', last_name: 'Name' }
        patch :update, params: { id: user.id, user: new_attributes }

        user.reload
        expect(user.first_name).to eq('New')
        expect(user.last_name).to eq('Name')
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to eq(I18n.t('users.successful_update'))
      end
    end

    context 'with invalid params' do
      it 'does not update the user and renders the edit template' do
        patch :update, params: { id: user.id, user: { first_name: '' } }

        user.reload
        expect(user.first_name).not_to eq('')
        expect(response).to render_template(:edit)
        expect(flash[:validation_error]).to eq(assigns(:current_user).errors.full_messages)
      end
    end
  end
end
