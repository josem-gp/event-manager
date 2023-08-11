require 'rails_helper'

RSpec.describe DisableInvitationJob, type: :job do
  let(:invitation) { create :invitation }

  it 'disables the invitation' do
    expect(invitation).not_to be_expired

    described_class.perform_now(invitation)

    invitation.reload
    expect(invitation).to be_expired
  end
end
