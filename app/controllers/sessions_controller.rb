class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(auth)
    if user.present?
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Logged in!'
    else
      redirect_to new_session_path, notice: "#{auth.info.email} is not authorized."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out!'
  end

  private

  def auth
    @auth ||= request.env["omniauth.auth"]
  end
end
