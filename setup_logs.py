#!/usr/bin/env python3
"""
Create logs table and add initial entries for Railway
"""
import mysql.connector

def setup_logs():
    config = {
        'host': 'caboose.proxy.rlwy.net',
        'port': 51406,
        'user': 'root',
        'password': 'lTUapGaKJUYSHtvUaHmUpEYUltXmevXC',
        'database': 'railway'
    }
    
    try:
        connection = mysql.connector.connect(**config)
        cursor = connection.cursor()
        
        # Create logs table
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
                payload JSON
            )
        """)
        
        # Add sample log entries
        sample_logs = [
            ("system_startup", None, None, "system", "127.0.0.1", "Railway Platform", '{"status": "initialized", "version": "1.0"}'),
            ("database_connected", None, None, "system", "127.0.0.1", "Railway Platform", '{"database": "railway", "status": "connected"}'),
            ("app_deployed", None, None, "system", "127.0.0.1", "Railway Platform", '{"deployment": "success"}'),
        ]
        
        for log in sample_logs:
            cursor.execute("""
                INSERT INTO app_logs (action, user_id, user_email, user_role, ip_address, user_agent, payload)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, log)
        
        connection.commit()
        print("✅ Logs table created with sample entries!")
        
        # Verify
        cursor.execute("SELECT COUNT(*) FROM app_logs")
        count = cursor.fetchone()[0]
        print(f"📊 Total log entries: {count}")
        
        cursor.close()
        connection.close()
        
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    from datetime import datetime
    setup_logs()
