require 'rails_helper'

RSpec.feature 'Sign in with OmniAuth', type: :feature do
  scenario 'User can sign in using OmniAuth' do
    visit new_user_session_path

    within('.d-flex.justify-content-center') do
      click_button('Login with Google Omniauth')
    end

    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Successfully authenticated from Google account.")
  end

  scenario 'User signs in unsuccesfully using OmniAuth' do
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials

    visit new_user_session_path

    within('.d-flex.justify-content-center') do
      click_button('Login with Google Omniauth')
    end

    expect(page).to have_content("Could not authenticate you from GoogleOauth2")
  end
end
