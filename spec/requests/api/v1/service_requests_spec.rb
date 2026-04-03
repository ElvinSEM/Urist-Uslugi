require "rails_helper"

RSpec.describe "Api::V1::ServiceRequests", type: :request do
  describe "POST /api/v1/service_requests" do
    it "creates request for authenticated user" do
      user = create(:user)
      service = create(:service)
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first

      post "/api/v1/service_requests",
        params: { service_request: attributes_for(:service_request, service_id: service.id) },
        headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:created)
    end
  end
end
