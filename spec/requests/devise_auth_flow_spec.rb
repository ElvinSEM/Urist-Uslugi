require "rails_helper"

RSpec.describe "Devise auth flow", type: :request do
  describe "GET /users/sign_up" do
    it "renders first name and last name fields" do
      get new_user_registration_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('name="user[first_name]"')
      expect(response.body).to include('name="user[last_name]"')
    end
  end

  describe "POST /users" do
    it "creates a user with names and redirects to root" do
      expect do
        post user_registration_path, params: {
          user: {
            first_name: "Ivan",
            last_name: "Petrov",
            email: "ivan@example.com",
            password: "Password123!",
            password_confirmation: "Password123!"
          }
        }
      end.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
    end

    it "shows validation errors when names are missing" do
      post user_registration_path, params: {
        user: {
          first_name: "",
          last_name: "",
          email: "broken@example.com",
          password: "Password123!",
          password_confirmation: "Password123!"
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Проверьте форму")
      expect(response.body).to include("Имя")
      expect(response.body).to include("Фамилия")
    end
  end

  describe "POST /users/sign_in" do
    it "logs in a user, respects remember me, and redirects to root" do
      user = create(:user, first_name: "Olga", last_name: "Sidorova", email: "olga@example.com")

      post user_session_path, params: {
        user: {
          email: user.email,
          password: "Password123!",
          remember_me: "1"
        }
      }

      expect(response).to redirect_to(root_path)
    end
  end

  describe "DELETE /users/sign_out" do
    it "logs out and returns to the login page" do
      user = create(:user)
      sign_in user

      delete destroy_user_session_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
