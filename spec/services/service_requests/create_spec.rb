require "rails_helper"

RSpec.describe ServiceRequests::Create do
  it "creates request" do
    client = create(:user)
    service = create(:service)

    request = described_class.call(
      actor: client,
      params: attributes_for(:service_request, service_id: service.id)
    )

    expect(request).to be_persisted
    expect(request.client).to eq(client)
  end
end
