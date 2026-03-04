-- Create app_logs table for Railway database
-- Run this in Railway MySQL console first

CREATE TABLE IF NOT EXISTS app_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(100) NOT NULL,
    user_id INT,
    user_email VARCHAR(255),
    user_role VARCHAR(50),
    ip_address VARCHAR(45),
    user_agent TEXT,
    payload JSON
);

-- Add indexes for better performance
CREATE INDEX idx_app_logs_timestamp ON app_logs(timestamp);
CREATE INDEX idx_app_logs_action ON app_logs(action);
CREATE INDEX idx_app_logs_user_email ON app_logs(user_email);
