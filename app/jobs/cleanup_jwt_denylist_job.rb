# app/jobs/cleanup_jwt_denylist_job.rb
class CleanupJwtDenylistJob < ApplicationJob
  queue_as :maintenance

  # Запускать раз в день
  def perform
    # Удаляем истекшие токены
    deleted_count = JwtDenylist.where("exp < ?", Time.current).delete_all

    Rails.logger.info "Cleaned up #{deleted_count} expired JWT tokens"

    # Если таблица разрослась, оптимизируем
    if deleted_count > 10_000
      ActiveRecord::Base.connection.execute("VACUUM ANALYZE jwt_denylists")
    end

    deleted_count
  end
end