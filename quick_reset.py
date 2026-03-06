#!/usr/bin/env python3
"""Quick reset ticket counter to 0 using direct SQL"""

import os
from dotenv import load_dotenv
import mysql.connector

load_dotenv()

def get_db_connection():
    database_url = os.getenv("DATABASE_URL")
    if database_url:
        import urllib.parse
        parsed = urllib.parse.urlparse(database_url)
        return mysql.connector.connect(
            host=parsed.hostname,
            user=parsed.username,
            password=parsed.password,
            database=parsed.path[1:],
            port=parsed.port or 3306
        )
    else:
        return mysql.connector.connect(
            host=os.getenv("DB_HOST", "localhost"),
            user=os.getenv("DB_USER", "root"),
            password=os.getenv("DB_PASSWORD", "root"),
            database=os.getenv("DB_NAME", "ticketing_db"),
            port=int(os.getenv("DB_PORT", "3306"))
        )

try:
    db = get_db_connection()
    cursor = db.cursor()
    
    # Reset auto-increment to 0
    cursor.execute("ALTER TABLE entries AUTO_INCREMENT = 0")
    db.commit()
    
    print("✅ Auto-increment reset to 0")
    
    # Verify the change
    cursor.execute("SHOW TABLE STATUS LIKE 'entries'")
    result = cursor.fetchone()
    if result:
        print(f"📊 Current auto-increment value: {result[10]}")
    
except Exception as e:
    print(f"❌ Error: {e}")
finally:
    if 'cursor' in locals():
        cursor.close()
    if 'db' in locals():
        db.close()
