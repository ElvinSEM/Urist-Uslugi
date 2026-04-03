class HealthController < ActionController::API
  def show
    ActiveRecord::Base.connection.execute("SELECT 1")
    render json: { status: "ok", time: Time.current.iso8601 }
  end
end
