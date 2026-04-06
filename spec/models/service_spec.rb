require "rails_helper"

RSpec.describe Service, type: :model do
  describe "scopes" do
    let(:category) { create(:category) }
    let!(:visible_service) { create(:service, category: category, published: true) }
    let!(:draft_service) { create(:service, category: category, published: false) }

    it "returns only published services" do
      expect(Service.published).to contain_exactly(visible_service)
    end

    it "filters by category" do
      expect(Service.for_category(category.id)).to include(visible_service, draft_service)
    end
  end
end
