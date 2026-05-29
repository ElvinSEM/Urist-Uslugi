require "rails_helper"

RSpec.describe "Service requests flow", type: :request do
  describe "POST /service_requests" do
    it "creates a guest request and redirects to the success page" do
      service = create(:service)

      expect do
        post service_requests_path, params: {
          service_request: {
            service_id: service.id,
            full_name: "Guest User",
            email: "guest@example.com",
            phone: "+79990001122",
            description: "Need help with a contract"
          }
        }
      end.to change(ServiceRequest, :count).by(1)

      expect(response).to redirect_to(success_service_requests_path)
    end

    it "renders validation errors for invalid submissions" do
      service = create(:service)

      post service_requests_path, params: {
        service_request: {
          service_id: service.id,
          full_name: "",
          email: "",
          phone: "",
          description: ""
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Проверьте форму")
    end
  end

  describe "GET /service_requests/success" do
    it "is publicly accessible" do
      get success_service_requests_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Заявка отправлена")
    end
  end
end
