module OmniauthHelpers
  def setup_mock_omniauth_valid_credentials
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    get :google_oauth2
  end

  def setup_mock_omniauth_invalid_credentials
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    get :google_oauth2
  end

  def reset_mock_omniauth
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(Faker::Omniauth.google)
  end
end
