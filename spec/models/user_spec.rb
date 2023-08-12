require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:created_events).with_foreign_key(:creator_id).dependent(:destroy) }
    it { should have_many(:invitees).dependent(:destroy) }
    it { should have_many(:events).through(:invitees) }
    it { should have_many(:sent_invitations).with_foreign_key(:sender_id).dependent(:destroy) }
    it { should have_many(:received_invitations).with_foreign_key(:recipient_id).dependent(:nullify) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should allow_value('John', '123').for(:first_name) }
    it { should_not allow_value('123', '!@#').for(:first_name).on(:update) }
    it { should allow_value('Doe', '456').for(:last_name) }
    it { should_not allow_value('456', '!@#').for(:last_name).on(:update) }

    context "when validating email" do
      subject { create :user, email: "example@test.io" }

      it 'is unique and case insensitive' do
        new_user = build(:user, email: subject.email.upcase)
        expect(new_user).to validate_uniqueness_of(:email).case_insensitive
      end

      it 'cannot be updated' do
        expect do
          subject.update(email: 'example1@test.io')
        end.not_to(change { subject.reload.email })

        expect(subject.errors[:email]).to include('cannot be updated')
      end
    end
  end

  describe '.from_omniauth' do
    context 'when user with email exists' do
      let(:auth) do
        double('auth', info: double('info', email: 'test@example.com', first_name: 'John', last_name: 'Doe'))
      end

      it 'returns existing user' do
        existing_user = create(:user, email: 'test@example.com')
        expect(User.from_omniauth(auth)).to eq(existing_user)
      end
    end

    context 'when user with email does not exist' do
      let(:auth) do
        double('auth', info: double('info', email: 'new@example.com', first_name: 'Jane', last_name: 'Smith'))
      end

      it 'creates a new user' do
        expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
      end
    end

    context 'when auth is invalid' do
      let(:auth) do
        double('auth')
      end

      it 'returns nil' do
        expect(User.from_omniauth(auth)).to eq(nil)
      end
    end
  end

  describe '#an_invitee?' do
    subject { create(:invitee) }

    it 'returns true when user is an invitee' do
      expect(subject.user.an_invitee?(subject.event)).to be true
    end

    context 'when user is not an invitee' do
      let(:new_user) { create(:user) }
      it 'returns false' do
        expect(new_user.an_invitee?(subject.event)).to be false
      end
    end
  end
end
