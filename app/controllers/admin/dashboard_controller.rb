class Admin::DashboardController < Admin::BaseController
  def index
    @stats = {
      users: User.count,
      lawyers: User.lawyer.count,
      services: Service.count,
      requests: ServiceRequest.count,
      pending_requests: ServiceRequest.pending.count
    }
    @recent_requests = ServiceRequest.includes(:service, :client).recent.limit(10)
  end
end
