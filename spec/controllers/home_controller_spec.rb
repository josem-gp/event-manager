require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    context 'when user is authenticated' do
      let(:user) { create :user }
      let!(:creator_event) { create(:event, creator: user, date: Date.current.beginning_of_week) }
      let(:invitee_event) { create(:event, date: Date.current.end_of_week) }

      before do
        sign_in(user)
        create(:invitee, user:, event: invitee_event)
      end

      it 'fetches events created and accepted by the user in the current week' do
        get :index

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(assigns(:all_events)).to eq([creator_event, invitee_event])
      end
    end

    context 'when user is not authenticated' do
      it 'returns a successful response and returns nil for the events' do
        get :index

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(assigns(:all_events)).to eq(nil)
      end
    end
  end
end
