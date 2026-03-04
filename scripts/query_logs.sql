-- Query to view logs from Railway database
-- Run this in Railway MySQL console

-- View recent logs
SELECT 
    id,
    timestamp,
    action,
    user_email,
    user_role,
    ip_address,
    LEFT(payload, 100) as payload_preview
FROM app_logs 
ORDER BY timestamp DESC 
LIMIT 50;

-- View logs by specific action
SELECT 
    id,
    timestamp,
    action,
    user_email,
    user_role,
    payload
FROM app_logs 
WHERE action = 'ticket_deleted'
ORDER BY timestamp DESC;

-- View logs by date range
SELECT 
    id,
    timestamp,
    action,
    user_email,
    user_role,
    payload
FROM app_logs 
WHERE DATE(timestamp) BETWEEN '2026-03-01' AND '2026-03-04'
ORDER BY timestamp DESC;

-- Count logs by action type
SELECT 
    action,
    COUNT(*) as count
FROM app_logs 
GROUP BY action 
ORDER BY count DESC;
