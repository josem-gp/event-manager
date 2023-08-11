require 'rails_helper'

RSpec.feature 'User Profile Updates', type: :feature do
  let(:user) { create(:user) }

  before do
    login_as(user)
    visit edit_user_path(user)
  end

  scenario 'User can update their first name and last name' do
    new_first_name = 'NewFirstName'
    new_last_name = 'NewLastName'

    fill_in 'First name', with: new_first_name
    fill_in 'Last name', with: new_last_name
    click_button 'Submit'

    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Welcome #{new_first_name} #{new_last_name}")
  end

  scenario 'User profile form guards against invalid inputs' do
    fill_in 'First name', with: ''
    fill_in 'Last name', with: ''
    click_button 'Submit'

    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
  end
end
