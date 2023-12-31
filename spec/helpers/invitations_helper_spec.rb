require 'rails_helper'

RSpec.describe InvitationsHelper, type: :helper do
  describe '#show_invitees?' do
    let(:event) { create :event }

    context 'when current user is only the creator' do
      it_behaves_like 'show invitees', true, false, true
    end

    context 'when current user is only an invitee' do
      it_behaves_like 'show invitees', false, true, true
    end

    context 'when current user is both the creator and invitee' do
      it_behaves_like 'show invitees', true, true, true
    end

    context 'when current user is not the creator and is not an invitee' do
      it_behaves_like 'show invitees', false, false, false
    end
  end

  describe '#invitation_expired?' do
    let(:non_expired_invitation) { create :invitation }
    let(:expired_invitation) { create :invitation, expired: true }

    it 'returns false for non-expired invitation' do
      expect(helper.invitation_expired?(non_expired_invitation)).to be(false)
    end

    it 'returns true for expired invitation' do
      expect(helper.invitation_expired?(expired_invitation)).to be(true)
    end
  end
end
