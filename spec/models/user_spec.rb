require "rails_helper"

RSpec.describe User, type: :model do
  describe "role scopes" do
    let!(:lawyer_user) { create(:user, role: :lawyer) }
    let!(:client_user) { create(:user, role: :client) }

    it "returns lawyers" do
      expect(User.lawyers).to include(lawyer_user)
      expect(User.lawyers).not_to include(client_user)
    end

    it "returns clients" do
      expect(User.clients).to include(client_user)
      expect(User.clients).not_to include(lawyer_user)
    end

    it "filters by role name" do
      expect(User.with_role(:lawyer)).to match_array([lawyer_user])
      expect(User.with_role(nil)).to include(lawyer_user, client_user)
    end
  end
end
