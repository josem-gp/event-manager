class UsersController < ApplicationController
  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path, notice: t('users.successful_update')
    else
      flash.now[:alert] = current_user.errors.full_messages
      render :edit, status: :unprocessable_entity, content_type: "text/html"
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end