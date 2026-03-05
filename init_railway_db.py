#!/usr/bin/env python3
"""
Initialize Railway database with required tables
"""

import os
import sys
import json
from datetime import datetime

# Add project directory to Python path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

try:
    from app import get_db_connection
    print("🔧 Initializing Railway database...")
    
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)
    
    # Create app_logs table with proper schema
    cursor.execute("""
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
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
    """)
    
    # Insert initial system logs
    cursor.execute("""
        INSERT INTO app_logs (action, payload) 
        SELECT action, payload FROM (
            SELECT 'system_startup' as action, '{"message": "Application initialized", "environment": "railway"}' as payload
            UNION ALL
            SELECT 'database_connected' as action, '{"database": "ticketing_db", "status": "connected"}' as payload
            UNION ALL
            SELECT 'app_deployed' as action, '{"version": "1.0.0", "platform": "railway", "timestamp": "' + datetime.now().strftime('%Y-%m-%d %H:%M:%S') + '"}' as payload
        ) as init_logs
        WHERE NOT EXISTS (SELECT 1 FROM app_logs WHERE action IN ('system_startup', 'database_connected', 'app_deployed'))
    """)
    
    db.commit()
    
    # Verify table exists and has data
    cursor.execute("SELECT COUNT(*) as count FROM app_logs")
    result = cursor.fetchone()
    print(f"✅ app_logs table ready with {result['count']} records")
    
    cursor.close()
    db.close()
    print("🚀 Railway database initialization complete!")
    
except Exception as e:
    print(f"❌ Error initializing database: {e}")
    sys.exit(1)
