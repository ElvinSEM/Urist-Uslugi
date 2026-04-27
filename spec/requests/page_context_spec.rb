require "rails_helper"

RSpec.describe "Page context", type: :request do
  describe "services index" do
    before do
      create_list(:service, 2)
      get services_path
    end

    it "renders meta tags with the configured title" do
      expect(response.body).to include("Юридические услуги")
    end

    it "renders breadcrumbs" do
      expect(response.body).to include('class="breadcrumbs"')
      expect(response.body).to include("Услуги")
    end
  end

  describe "category show" do
    let(:category) { create(:category, name: "Сделки", description: "Описание нюансов") }

    before do
      create(:service, category: category)
      get category_path(category)
    end

    it "renders the category name in breadcrumbs" do
      expect(response.body).to include("Сделки")
      expect(response.body).to include('class="breadcrumbs"')
    end
  end

  describe "service request index" do
    let(:client) { create(:user) }

    before do
      sign_in client
      get service_requests_path
    end

    it "shows the requests page and breadcrumbs" do
      expect(response).to be_successful
      expect(response.body).to include("Мои заявки")
      expect(response.body).to include('class="breadcrumbs"')
    end
  end
end
