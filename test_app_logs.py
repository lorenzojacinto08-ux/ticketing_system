#!/usr/bin/env python3
"""
Test script to check app_logs table and populate with test data
"""

import os
import sys
import json
from datetime import datetime

# Add the project directory to Python path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

try:
    from app import get_db_connection
except ImportError:
    print("❌ Cannot import app module. Make sure you're in the correct directory.")
    sys.exit(1)

def check_app_logs():
    """Check app_logs table structure and contents"""
    
    print("🔍 Checking app_logs table...")
    
    try:
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        
        # Check if table exists
        cursor.execute("SHOW TABLES LIKE 'app_logs'")
        table_exists = cursor.fetchone()
        
        if table_exists:
            print("✅ app_logs table exists")
            
            # Show table structure
            cursor.execute("DESCRIBE app_logs")
            columns = cursor.fetchall()
            print("\n📋 Table structure:")
            for col in columns:
                print(f"  - {col['Field']}: {col['Type']}")
            
            # Count records
            cursor.execute("SELECT COUNT(*) as count FROM app_logs")
            count_result = cursor.fetchone()
            print(f"\n📊 Total records: {count_result['count']}")
            
            # Show recent records
            cursor.execute("SELECT * FROM app_logs ORDER BY timestamp DESC LIMIT 5")
            recent_logs = cursor.fetchall()
            
            if recent_logs:
                print(f"\n📝 Recent {len(recent_logs)} records:")
                for log in recent_logs:
                    print(f"  {log['timestamp']} - {log['action']}")
                    if log.get('payload'):
                        try:
                            payload_data = json.loads(log['payload'])
                            if isinstance(payload_data, dict):
                                for key, value in payload_data.items():
                                    print(f"    {key}: {value}")
                        except:
                            print(f"    Payload: {log['payload']}")
            else:
                print("❌ No records found in app_logs table")
        else:
            print("❌ app_logs table does not exist")
            
            # Create table for testing
            print("\n🔧 Creating app_logs table...")
            cursor.execute("""
                CREATE TABLE app_logs (
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
            db.commit()
            print("✅ app_logs table created")
            
            # Insert test log entries
            print("\n🧪 Inserting test log entries...")
            test_logs = [
                ("system_startup", {"message": "Application started"}),
                ("database_connected", {"database": "ticketing_db"}),
                ("app_deployed", {"version": "1.0.0", "environment": "production"}),
                ("user_login", {"user_id": 1, "email": "test@example.com"}),
                ("ticket_created", {"ticket_no": 123, "store_name": "Test Store"}),
            ]
            
            for action, payload in test_logs:
                cursor.execute("""
                    INSERT INTO app_logs (action, user_id, user_email, user_role, ip_address, user_agent, payload)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """, (action, None, None, None, "127.0.0.1", "Test-Agent", json.dumps(payload)))
            
            db.commit()
            print(f"✅ Inserted {len(test_logs)} test log entries")
        
        cursor.close()
        db.close()
        
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    check_app_logs()
