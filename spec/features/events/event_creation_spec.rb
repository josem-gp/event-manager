# spec/features/event_creation_spec.rb
require 'rails_helper'

RSpec.feature 'Event Creation', type: :feature do
  let(:user) { create(:user) }

  before do
    login_as(user)
    visit new_event_path
  end

  scenario 'User can create an event successfully' do
    fill_in 'Title', with: 'Event Title'
    fill_in 'Description', with: 'Event Description'
    fill_in 'Date', with: Date.tomorrow.strftime('%Y-%m-%d')
    click_button 'Submit'

    expect(page).to have_content('Event created successfully.')
  end

  scenario 'Event creation requires title, description, date, and time' do
    click_button 'Submit'

    expect(page).to have_content("can't be blank")
  end

  scenario 'Event form guards against invalid inputs' do
    fill_in 'Title', with: 'Event Title'
    fill_in 'Description', with: 'Event Description'
    fill_in 'Date', with: ''
    click_button 'Submit'

    expect(page).to have_content("Date can't be blank")
  end
end
