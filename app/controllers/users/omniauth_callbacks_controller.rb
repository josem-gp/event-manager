# frozen_string_literal: true

module Users
  OMNIAUTH_ERROR = "Google OAuth2 authentication failed"

  class OmniauthError < StandardError; end

  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      user = User.from_omniauth(auth)
      if user.present?
        handle_successful_authentication(user)
      else
        handle_failed_authentication
      end
    end

    private

    def auth
      @auth ||= request.env["omniauth.auth"]
    end

    def handle_successful_authentication(user)
      sign_out_all_scopes
      flash[:notice] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect user, event: :authentication
    end

    def handle_failed_authentication
      log_error(OmniauthError.new("Google OAuth2 authentication failed for email #{auth.info.email}."),
                OMNIAUTH_ERROR)
      flash[:error] =
        t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
      redirect_to new_user_sessions_path
    end
  end
end
