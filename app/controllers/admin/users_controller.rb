class Admin::UsersController < Admin::BaseController
  def index
    @users = User.order(created_at: :desc)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update!(user_params)
    redirect_to admin_users_path, notice: "Пользователь обновлен"
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role)
  end
end
