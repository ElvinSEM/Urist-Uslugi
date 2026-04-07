class Admin::UsersController < Admin::CrudController
  private

  def resource_class
    User
  end

  def collection_scope
    User.order(created_at: :desc)
  end

  def resource_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :password, :password_confirmation).tap do |attrs|
      attrs.delete(:password) if attrs[:password].blank?
      attrs.delete(:password_confirmation) if attrs[:password_confirmation].blank?
    end
  end

  def resource_label
    "Пользователь"
  end
end
