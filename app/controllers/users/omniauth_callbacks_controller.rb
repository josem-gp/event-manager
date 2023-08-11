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
      error_message = determine_error_message

      log_error(OmniauthError.new(error_message),
                OMNIAUTH_ERROR)
      flash[:error] =
        t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: error_message
      redirect_to new_user_registration_path
    end

    def determine_error_message
      if auth.respond_to?(:info) && auth.info.respond_to?(:email) && auth.info.email.present?
        "Google OAuth2 authentication failed for email #{auth.info.email}."
      else
        "Authentication failed."
      end
    end
  end
end
