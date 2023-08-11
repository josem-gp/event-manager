require 'rails_helper'

RSpec.describe EventsHelper, type: :helper do
  describe '#formatted_event_date' do
    it 'returns a formatted date' do
      date = Date.new(2023, 8, 15)
      expect(formatted_event_date(date)).to eq('August 15')
    end
  end

  describe '#event_weekday' do
    it 'returns the weekday of the date' do
      date = Date.new(2023, 8, 15) # A Tuesday
      expect(event_weekday(date)).to eq('Tuesday')
    end
  end

  describe '#event_time' do
    it 'returns a formatted time' do
      time = Time.new(2023, 8, 15, 14, 30)
      expect(event_time(time)).to eq('02:30 PM')
    end
  end

  describe '#creator_full_name' do
    it 'returns the full name of the creator' do
      creator = double('User', first_name: 'John', last_name: 'Doe')
      expect(creator_full_name(creator)).to eq('John Doe')
    end
  end

  describe '#invitee_full_name' do
    it 'returns the full name of the invitee user' do
      invitee_user = double('User', first_name: 'Jane', last_name: 'Smith')
      expect(invitee_full_name(invitee_user)).to eq('Jane Smith')
    end
  end
end
