require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:invitation) { create(:invitation, event:) }

  before { sign_in(user) }

  describe 'POST #accept' do
    context 'when invitation can be accepted' do
      it 'creates a new invitee and marks invitation as accepted' do
        expect do
          post :accept, params: { id: invitation.id, event_id: event.id }
        end.to change(Invitee, :count).by(1)
                                      .and change { invitation.reload.status }.to('accepted')
      end

      it 'sets a flash success' do
        post :accept, params: { id: invitation.id, event_id: event.id }
        expect(flash[:success]).to eq(I18n.t('invitations.accepted'))
      end

      it 'redirects to event page' do
        post :accept, params: { id: invitation.id, event_id: event.id }
        expect(response).to redirect_to(event_path(event))
      end
    end

    context 'when invitation cannot be accepted' do
      before do
        allow_any_instance_of(Invitee).to receive(:save).and_return(false)
      end

      it 'does not create a new invitee' do
        expect do
          post :accept, params: { id: invitation.id, event_id: event.id }
        end.not_to change(Invitee, :count)
      end

      it 'sets flash error' do
        post :accept, params: { id: invitation.id, event_id: event.id }
        expect(flash[:error]).to eq(I18n.t('invitations.error_when_accepting'))
      end

      it 'redirects to event page' do
        post :accept, params: { id: invitation.id, event_id: event.id }
        expect(response).to redirect_to(event_path(event))
      end
    end
  end

  describe 'POST #reject' do
    it 'marks the invitation as denied and sets flash success' do
      post :reject, params: { id: invitation.id, event_id: event.id }
      expect(invitation.reload.status).to eq('denied')
      expect(flash[:success]).to eq(I18n.t('invitations.denied'))
      expect(response).to redirect_to(event_path(event))
    end
  end
end
