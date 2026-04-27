require "rails_helper"

RSpec.describe CleanupJwtDenylistJob, type: :job do
  describe "#perform" do
    it "removes expired tokens and returns deleted count" do
      create(:user)
      create(:jwt_denylist, exp: 1.day.ago.to_i)
      create(:jwt_denylist, exp: 1.day.from_now.to_i)

      result = described_class.perform_now

      expect(result).to eq(1)
      expect(JwtDenylist.count).to eq(1)
    end

    it "runs vacuum analyze when many rows are removed" do
      relation = instance_double(ActiveRecord::Relation, delete_all: 10_001)
      allow(JwtDenylist).to receive(:where).and_return(relation)
      allow(ActiveRecord::Base.connection).to receive(:execute)

      described_class.perform_now

      expect(ActiveRecord::Base.connection).to have_received(:execute).with("VACUUM ANALYZE jwt_denylists")
    end
  end
end
