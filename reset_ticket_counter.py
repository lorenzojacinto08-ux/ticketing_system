#!/usr/bin/env python3
"""
Reset ticket counter script
This script resets the auto-increment counter for the entries table.
"""

import os
from dotenv import load_dotenv
import mysql.connector

# Load environment variables
load_dotenv()

def get_db_connection():
    """Get database connection using same logic as app.py"""
    database_url = os.getenv("DATABASE_URL")
    
    if database_url:
        # Parse DATABASE_URL format: mysql://username:password@host:port/database
        import urllib.parse
        parsed = urllib.parse.urlparse(database_url)
        return mysql.connector.connect(
            host=parsed.hostname,
            user=parsed.username,
            password=parsed.password,
            database=parsed.path[1:],  # Remove leading slash
            port=parsed.port or 3306
        )
    else:
        # Fall back to individual environment variables
        return mysql.connector.connect(
            host=os.getenv("DB_HOST", "localhost"),
            user=os.getenv("DB_USER", "root"),
            password=os.getenv("DB_PASSWORD", "root"),
            database=os.getenv("DB_NAME", "ticketing_db"),
            port=int(os.getenv("DB_PORT", "3306"))
        )

def reset_ticket_counter():
    """Reset the auto-increment counter for entries table"""
    try:
        db = get_db_connection()
        cursor = db.cursor()
        
        # Check if entries table exists and get its structure
        cursor.execute("SHOW TABLES LIKE 'entries'")
        if not cursor.fetchone():
            print("❌ Error: 'entries' table not found")
            return False
        
        # Get table structure to find primary key
        cursor.execute("DESCRIBE entries")
        columns = cursor.fetchall()
        
        # Find auto-increment column
        auto_increment_col = None
        for col in columns:
            if col[5] == 'auto_increment':  # Extra column contains 'auto_increment'
                auto_increment_col = col[0]
                break
        
        if not auto_increment_col:
            print("❌ Error: No auto-increment column found in entries table")
            return False
        
        # Get current highest ticket number
        cursor.execute(f"SELECT MAX({auto_increment_col}) FROM entries")
        max_id = cursor.fetchone()[0] or 0
        
        print(f"📊 Current highest {auto_increment_col}: {max_id}")
        
        # Confirm before proceeding
        confirm = input(f"\n⚠️  This will reset the auto-increment counter to 1.\n"
                        f"   New tickets will start from number 1.\n"
                        f"   Are you sure you want to continue? (yes/no): ")
        
        if confirm.lower() != 'yes':
            print("❌ Operation cancelled")
            return False
        
        # Reset the auto-increment counter
        cursor.execute(f"ALTER TABLE entries AUTO_INCREMENT = 1")
        db.commit()
        
        print(f"✅ Successfully reset {auto_increment_col} counter to 1")
        print("🎫 New tickets will start from number 1")
        
        return True
        
    except mysql.connector.Error as e:
        print(f"❌ Database error: {e}")
        return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals():
            db.close()

if __name__ == "__main__":
    print("🔄 Ticket Counter Reset Tool")
    print("=" * 40)
    reset_ticket_counter()
