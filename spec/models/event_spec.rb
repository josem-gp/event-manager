require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'associations' do
    it { should belong_to(:creator).class_name('User').inverse_of(:created_events) }
    it { should have_many(:invitees).dependent(:destroy) }
    it { should have_many(:users).through(:invitees) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:time) }
  end

  describe 'callbacks' do
    describe '#single_event_per_date_and_time' do
      context 'when no overlapping event exists' do
        subject { build :event }
        it 'does not add errors' do
          expect(subject).to be_valid
        end
      end

      context 'when overlapping event exists' do
        let(:existing_event) { create :event }
        let(:overlapping_event) { build(:event, creator: existing_event.creator, date: existing_event.date + 30.minutes) }
        it 'adds an error' do
          expect(overlapping_event).to be_invalid
          expect(overlapping_event.errors[:base]).to include("Another event already exists at this date and time")
        end
      end
    end
  end
end
