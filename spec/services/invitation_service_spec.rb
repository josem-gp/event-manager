require 'rails_helper'

RSpec.describe Services::InvitationService, type: :service do
  describe '#call' do
    let(:event) { create(:event) }
    let!(:invitee1) { create(:user, email: 'invitee1@example.com') }
    let(:invitee_emails) { invitee1.email }
    let(:parameterized_mailer) { double('ActionMailer::Parameterized::Mailer') }
    let(:parameterized_message) { double('ActionMailer::Parameterized::MessageDelivery') }

    subject(:invitation_service) { described_class.new(event, invitee_emails) }

    before do
      allow(EventInvitationMailer).to receive(:with).and_return(parameterized_mailer)
      allow(parameterized_mailer).to receive(:send_invitation).and_return(parameterized_message)
      allow(parameterized_message).to receive(:deliver_later)
    end

    context 'when invitees exist and successfull invitation' do
      let(:invitee_emails) { 'invitee1@example.com, invitee2@example.com' }
      let!(:invitee2) { create(:user, email: 'invitee2@example.com') }
      let(:invitees) { [invitee1, invitee2] }

      it 'creates and sends invitations for valid invitees' do
        invitation_service.call

        expect(EventInvitationMailer).to have_received(:with).with(
          recipient: invitee1, sender: event.creator,
          url: "#{ENV.fetch('APP_URL', nil)}/events/#{event.id}"
        ).exactly(1).times

        expect(EventInvitationMailer).to have_received(:with).with(
          recipient: invitee2, sender: event.creator,
          url: "#{ENV.fetch('APP_URL', nil)}/events/#{event.id}"
        ).exactly(1).times

        expect(parameterized_mailer).to have_received(:send_invitation).twice
        expect(parameterized_message).to have_received(:deliver_later).twice
      end

      it 'enqueues DisableInvitationJob for each invitation' do
        invitation_service.call

        invitees.each do |invitee|
          expect(DisableInvitationJob).to have_been_enqueued
            .with(invitation: invitee.received_invitations.last)
            .on_queue("default")
            .at(be_within(1.second).of(1.day.from_now))
            .exactly(:once)
        end
      end

      it "does not throw any error" do
        expect(invitation_service.instance_variable_get(:@invitation_errors)).to eq(0)
      end
    end

    context 'when invitees do not exist' do
      let(:invitee_emails) { 'nonexistent1@example.com, nonexistent2@example.com' }

      it_behaves_like 'error handling', 'InviteeNotFoundError', 2
    end

    context 'when user has invitation already' do
      let!(:existing_invitation) { create(:invitation, event:, recipient: invitee1) }

      it_behaves_like 'error handling', 'HasActiveInvitationError', 1
    end

    context 'when invitation throws error when saved' do
      before do
        allow_any_instance_of(Invitation).to receive(:save).and_return(false)
      end

      it_behaves_like 'error handling', 'InvitationCreationError', 1
    end

    context 'when InvitationMailerError is raised' do
      let(:parameterized_mailer) { double('ActionMailer::Parameterized::Mailer') }

      before do
        allow(EventInvitationMailer).to receive(:with).and_return(parameterized_mailer)
        allow(parameterized_mailer).to receive(:send_invitation).and_raise(StandardError)
      end

      it_behaves_like 'error handling', 'InvitationMailerError', 1
    end

    context 'when DisableInvitationJobError is raised' do
      let(:invitation) { create :invitation, recipient: invitee1 }

      before do
        allow(DisableInvitationJob).to receive(:set)
        allow(DisableInvitationJob).to receive(:perform_later).with(invitation:).and_raise(StandardError)
      end

      it_behaves_like 'error handling', 'DisableInvitationJobError', 1
    end
  end
end
