-- daily_stats
CREATE MATERIALIZED VIEW IF NOT EXISTS daily_stats AS
WITH dates AS (
  SELECT generate_series(
    date_trunc('day', NOW() - INTERVAL '30 days'),
    date_trunc('day', NOW()),
    '1 day'::interval
  )::date AS day
)
SELECT
    dates.day,
    COUNT(DISTINCT users.id) AS new_users,
    COUNT(DISTINCT CASE WHEN users.role = 1 THEN users.id END) AS new_lawyers,
    COUNT(DISTINCT service_requests.id) AS total_requests,
    COUNT(DISTINCT CASE WHEN service_requests.status = 0 THEN service_requests.id END) AS pending_requests,
    COUNT(DISTINCT CASE WHEN service_requests.status = 1 THEN service_requests.id END) AS in_progress_requests,
    COUNT(DISTINCT CASE WHEN service_requests.status = 2 THEN service_requests.id END) AS completed_requests,
    COUNT(DISTINCT CASE WHEN service_requests.status = 3 THEN service_requests.id END) AS rejected_requests,
    COALESCE(SUM(services.price_cents), 0) AS revenue_cents
FROM dates
         LEFT JOIN users ON date_trunc('day', users.created_at) = dates.day
         LEFT JOIN service_requests ON date_trunc('day', service_requests.created_at) = dates.day
         LEFT JOIN services ON service_requests.service_id = services.id
GROUP BY dates.day
ORDER BY dates.day DESC;

CREATE UNIQUE INDEX IF NOT EXISTS idx_daily_stats_day ON daily_stats(day);