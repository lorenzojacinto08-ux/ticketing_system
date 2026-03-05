-- Create transactions table for audit logging
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    user_email VARCHAR(255),
    user_role VARCHAR(50),
    action_type VARCHAR(50) NOT NULL, -- 'create', 'update', 'delete'
    table_name VARCHAR(50) NOT NULL, -- 'tickets', 'users'
    record_id INT,
    old_values JSON,
    new_values JSON,
    description TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
