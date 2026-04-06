# db/migrate/20260402001400_create_materialized_views_for_analytics.rb
class CreateMaterializedViewsForAnalytics < ActiveRecord::Migration[8.1]
  def up
    # Ежедневная статистика
    execute <<-SQL
      CREATE MATERIALIZED VIEW IF NOT EXISTS daily_stats AS
      WITH dates AS (
        SELECT generate_series(
          date_trunc('day', NOW() - INTERVAL '30 days'),
          date_trunc('day', NOW()),
          '1 day'::interval
        )::date as day
      )
      SELECT 
        dates.day,
        COUNT(DISTINCT users.id) as new_users,
        COUNT(DISTINCT CASE WHEN users.role = 1 THEN users.id END) as new_lawyers,
        COUNT(DISTINCT service_requests.id) as total_requests,
        COUNT(DISTINCT CASE WHEN service_requests.status = 0 THEN service_requests.id END) as pending_requests,
        COUNT(DISTINCT CASE WHEN service_requests.status = 1 THEN service_requests.id END) as in_progress_requests,
        COUNT(DISTINCT CASE WHEN service_requests.status = 2 THEN service_requests.id END) as completed_requests,
        COUNT(DISTINCT CASE WHEN service_requests.status = 3 THEN service_requests.id END) as rejected_requests,
        COALESCE(SUM(services.price_cents), 0) as revenue_cents
      FROM dates
      LEFT JOIN users ON date_trunc('day', users.created_at) = dates.day
      LEFT JOIN service_requests ON date_trunc('day', service_requests.created_at) = dates.day
      LEFT JOIN services ON service_requests.service_id = services.id
      GROUP BY dates.day
      ORDER BY dates.day DESC;
      
      CREATE UNIQUE INDEX IF NOT EXISTS idx_daily_stats_day ON daily_stats(day);
    SQL

    # Топ услуг
    execute <<-SQL
      CREATE MATERIALIZED VIEW IF NOT EXISTS top_services AS
      SELECT 
        services.id,
        services.title,
        services.slug,
        COUNT(service_requests.id) as requests_count,
        AVG(EXTRACT(EPOCH FROM (service_requests.completed_at - service_requests.created_at))) as avg_completion_time_hours
      FROM services
      LEFT JOIN service_requests ON services.id = service_requests.service_id
      WHERE service_requests.created_at > NOW() - INTERVAL '90 days'
      GROUP BY services.id
      ORDER BY requests_count DESC
      LIMIT 100;
      
      CREATE UNIQUE INDEX IF NOT EXISTS idx_top_services_id ON top_services(id);
    SQL
  end

  def down
    execute "DROP MATERIALIZED VIEW IF EXISTS daily_stats"
    execute "DROP MATERIALIZED VIEW IF EXISTS top_services"
  end
end