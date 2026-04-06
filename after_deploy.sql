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

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'idx_daily_stats_day'
    ) THEN
CREATE UNIQUE INDEX idx_daily_stats_day ON daily_stats(day);
END IF;
END$$;

-- top_services
CREATE MATERIALIZED VIEW IF NOT EXISTS top_services AS
SELECT
    services.id,
    services.title,
    services.slug,
    COUNT(service_requests.id) AS requests_count,
    AVG(EXTRACT(EPOCH FROM (service_requests.completed_at - service_requests.created_at)))
                                  FILTER (WHERE service_requests.completed_at IS NOT NULL) AS avg_completion_time_hours
FROM services
         LEFT JOIN service_requests ON services.id = service_requests.service_id
WHERE service_requests.created_at > NOW() - INTERVAL '90 days'
GROUP BY services.id
ORDER BY requests_count DESC
    LIMIT 100;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'idx_top_services_id'
    ) THEN
CREATE UNIQUE INDEX idx_top_services_id ON top_services(id);
END IF;
END$$;