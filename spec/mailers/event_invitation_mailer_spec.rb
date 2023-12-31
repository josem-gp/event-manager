require 'rails_helper'

RSpec.describe EventInvitationMailer, type: :mailer do
  describe '#send_invitation' do
    let(:recipient) { build(:user, email: 'recipient@example.com') }
    let(:sender) { build(:user, email: 'sender@example.com') }
    let(:url) { 'https://example.com/events/135' }

    let(:mail) { EventInvitationMailer.with(recipient:, sender:, url:).send_invitation }

    it 'renders the headers' do
      expect(mail.subject).to eq(I18n.t('invitations.greetings'))
      expect(mail.to).to eq(['recipient@example.com'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('You have been invited!')
      expect(mail.body.encoded).to include('https://example.com/events/135')
    end
  end
end
