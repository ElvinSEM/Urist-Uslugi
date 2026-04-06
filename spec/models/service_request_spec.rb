require "rails_helper"

RSpec.describe ServiceRequest, type: :model do
  describe "scopes" do
    let(:client) { create(:user, role: :client) }
    let(:lawyer) { create(:user, role: :lawyer) }
    let!(:pending_request) { create(:service_request, client: client, lawyer: nil, status: :pending) }
    let!(:assigned_request) { create(:service_request, client: client, lawyer: lawyer, status: :in_progress) }

    it "filters by client" do
      result = ServiceRequest.for_client(client)
      expect(result).to include(pending_request, assigned_request)
    end

    it "returns assigned and unassigned requests" do
      expect(ServiceRequest.assigned).to contain_exactly(assigned_request)
      expect(ServiceRequest.unassigned).to contain_exactly(pending_request)
    end

    it "filters by status when provided" do
      expect(ServiceRequest.with_status(:pending)).to contain_exactly(pending_request)
    end
  end
end
