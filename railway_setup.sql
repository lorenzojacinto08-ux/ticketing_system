-- SQL query to create app_logs table on Railway
-- Copy and paste this into Railway MySQL terminal

-- First, select your database
USE ticketing_db;

-- Create the app_logs table with proper schema
CREATE TABLE IF NOT EXISTS app_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(100) NOT NULL,
    user_id INT,
    user_email VARCHAR(255),
    user_role VARCHAR(50),
    ip_address VARCHAR(45),
    user_agent TEXT,
    payload JSON,
    INDEX idx_timestamp (timestamp),
    INDEX idx_action (action),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Verify table was created
SHOW TABLES LIKE 'app_logs';

-- Check table structure
DESCRIBE app_logs;

-- Insert some test data to verify it works
INSERT INTO app_logs (action, payload) VALUES 
('system_startup', '{"message": "Database initialized manually", "environment": "railway", "timestamp": "2026-03-05 10:50:00"}');

-- Verify data was inserted
SELECT * FROM app_logs ORDER BY timestamp DESC LIMIT 5;
