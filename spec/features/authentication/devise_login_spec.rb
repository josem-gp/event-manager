require 'rails_helper'

RSpec.feature 'Log in with Devise', type: :feature do
  let(:user) { create(:user) }

  before do
    visit new_user_session_path
  end

  scenario 'User can log in successfully using Devise' do
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Signed in successfully.")
  end

  scenario "User logs in unsuccesfully using Devise" do
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_text('Invalid Email or password')
  end
end
