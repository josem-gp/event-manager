require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user) }
  let(:event_params) { attributes_for(:event) }

  describe 'GET #show' do
    let(:event) { create(:event) }

    context 'when user is authenticated' do
      let!(:invitation) { create(:invitation, event:, recipient: user) }

      before do
        sign_in(user)
        allow(controller).to receive(:log_error)
        get :show, params: { id: event.id }
      end

      it 'assigns @is_an_invitee and @invitation' do
        expect(assigns(:is_an_invitee)).to be_falsey
        expect(assigns(:invitation)).to eq(invitation)
      end

      it 'successfully renders the show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'when user is not authenticated' do
      before do
        get :show, params: { id: event.id }
      end

      it 'gets redirected to login page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #new' do
    context 'when user is authenticated' do
      before do
        sign_in(user)
        get :new
      end

      it 'assigns a new event' do
        expect(assigns(:event)).to be_a_new(Event)
      end

      it 'successfully renders the new template' do
        expect(response).to render_template(:new)
      end
    end

    context 'when user is not authenticated' do
      before do
        get :new
      end

      it 'gets redirected to login page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is authenticated' do
      before do
        sign_in(user)
      end

      context 'with valid params' do
        it 'creates a new event' do
          expect do
            post :create, params: { event: event_params }
          end.to change(Event, :count).by(1)
        end

        it 'successfully redirects to the root path and sets a success flash' do
          post :create, params: { event: event_params }
          expect(response).to redirect_to(root_path)
          expect(flash[:success]).to eq(I18n.t('events.successful_creation'))
        end
      end

      context 'with invalid params' do
        it 'does not create a new event' do
          expect do
            post :create, params: { event: { title: '' } }
          end.not_to change(Event, :count)
        end

        it 'renders the new template with unprocessable entity status' do
          post :create, params: { event: { title: '' } }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:new)
        end

        it 'assigns @event with errors and sets a flash error' do
          post :create, params: { event: { title: '' } }
          expect(assigns(:event).errors).not_to be_empty
          expect(flash[:validation_error]).to eq(assigns(:event).errors.full_messages)
        end
      end
    end

    context 'when user is not authenticated' do
      before do
        post :create, params: { event: event_params }
      end

      it 'gets redirected to login page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
