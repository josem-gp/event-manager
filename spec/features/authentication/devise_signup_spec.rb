require 'rails_helper'

RSpec.feature 'Sign up with Devise', type: :feature do
  scenario 'User can sign up successfully using Devise' do
    visit new_user_registration_path

    fill_in "First name", with: "John"
    fill_in "Last name", with: "Doe"
    fill_in "Email", with: "john@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Welcome John Doe")
  end

  scenario 'User signs up unsuccesfully using Devise' do
    visit new_user_registration_path

    click_button "Sign up"

    expect(page).to have_current_path(user_registration_path)
    expect(page).to have_content("can't be blank")
  end
end
