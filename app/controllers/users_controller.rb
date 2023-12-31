class UsersController < ApplicationController
  def edit; end

  def update
    if current_user.update(user_params)
      flash[:success] = t('users.successful_update')
      redirect_to root_path
    else
      flash_errors(current_user)
      render :edit, status: :unprocessable_entity, content_type: "text/html"
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
