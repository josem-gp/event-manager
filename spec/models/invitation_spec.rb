require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe 'associations' do
    it { should belong_to(:event) }
    it { should belong_to(:sender).class_name('User').inverse_of(:sent_invitations) }
    it { should belong_to(:recipient).class_name('User').inverse_of(:received_invitations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:url) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, accepted: 1, denied: 2) }
  end

  describe 'callbacks' do
    subject { create :invitation }

    it 'sets expiration_date after creation' do
      # To make up for the lag between instance creation and the callback action we use within
      expect(subject.expiration_date).to be_within(1.second).of(1.day.from_now)
    end
  end

  describe 'scopes' do
    let(:expired_invitation) { create(:invitation, expired: true) }
    let(:not_expired_invitation) { create(:invitation, expired: false) }

    it '.not_expired returns not expired invitations' do
      expect(Invitation.not_expired).to include(not_expired_invitation)
      expect(Invitation.not_expired).not_to include(expired_invitation)
    end

    it '.expired returns expired invitations' do
      expect(Invitation.expired).to include(expired_invitation)
      expect(Invitation.expired).not_to include(not_expired_invitation)
    end
  end

  describe 'status methods' do
    let(:invitation) { create(:invitation) }

    it '#pending?' do
      expect(invitation.pending?).to be true
    end

    it '#accepted?' do
      invitation.accepted!
      expect(invitation.accepted?).to be true
    end

    it '#denied?' do
      invitation.denied!
      expect(invitation.denied?).to be true
    end
  end

  describe '#disable_invitation' do
    let(:invitation) { create(:invitation) }

    it 'sets expired attribute to true' do
      invitation.disable_invitation
      expect(invitation.expired).to be true
    end
  end
end
