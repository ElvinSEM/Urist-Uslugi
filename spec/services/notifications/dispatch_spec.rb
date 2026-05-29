require "rails_helper"

RSpec.describe Notifications::Dispatch do
  include ActiveJob::TestHelper

  it "creates a single notification and enqueues delivery once" do
    user = create(:user)

    expect do
      perform_enqueued_jobs do
        described_class.call(
          user: user,
          title: "Статус заявки обновлен",
          body: "Заявка #1: completed"
        )
      end
    end.to change(Notification, :count).by(1)

    expect(Notification.last.user).to eq(user)
  end
end
