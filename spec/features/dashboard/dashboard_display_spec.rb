require 'rails_helper'

RSpec.feature 'Dashboard Display', type: :feature do
  let(:user) { create(:user) }

  context 'when no events in the week' do
    let!(:created_event) { create(:event, creator: user, date: Time.zone.today + 1.week) }

    before do
      login_as(user)
      visit root_path
    end

    scenario 'Dashboard is empty if user has no events for the current week' do
      expect(page).to have_no_css('.card-header')
    end
  end

  context 'when events in the week' do
    let!(:created_event) { create(:event, creator: user) }
    let(:invited_event) { create(:event) }

    before do
      login_as(user)
      create(:invitee, user:, event: invited_event)
      visit root_path
    end

    scenario 'Dashboard displays events created and accepted by the user for the current week' do
      [created_event, invited_event].each do |event|
        expect(page).to have_content(event.title)
      end
    end
  end
end
