require "rails_helper"

RSpec.describe "Api::V1::Services", type: :request do
  describe "GET /api/v1/services" do
    it "returns services" do
      create(:service)

      get "/api/v1/services"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).fetch("data")).not_to be_empty
    end
  end
end
