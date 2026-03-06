#!/usr/bin/env python3
"""
Simple debug script to test database connection without Flask dependencies
"""

import os
import mysql.connector
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def get_db_connection():
    # Try Railway's DATABASE_URL first, then fall back to individual variables
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

def test_database():
    """Test database connection and schema"""
    print("🔍 Testing database connection...")
    
    try:
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        print("✅ Database connection successful")
        
        # Check entries table structure
        print("\n📋 Checking entries table structure...")
        cursor.execute("SHOW COLUMNS FROM entries")
        columns = cursor.fetchall()
        col_names = [col['Field'] for col in columns]
        print(f"Available columns: {col_names}")
        
        # Check if critical columns exist
        critical_cols = ['ticket_no', 'store_name', 'subject', 'concern', 'job_order']
        missing_cols = [col for col in critical_cols if col not in col_names]
        
        if missing_cols:
            print(f"❌ Missing critical columns: {missing_cols}")
        else:
            print("✅ All critical columns present")
        
        # Test JO generation
        print("\n🔢 Testing JO generation...")
        if 'job_order' in col_names:
            try:
                cursor.execute(
                    """
                    SELECT
                        MAX(CAST(SUBSTRING(job_order, 5) AS UNSIGNED)) AS max_num
                    FROM entries
                    WHERE job_order IS NOT NULL
                      AND job_order REGEXP '^jo-[0-9]+$'
                    """
                )
                row = cursor.fetchone()
                max_num = row["max_num"] if row else None
                next_num = (int(max_num) if max_num is not None else 0) + 1
                result = f"jo-{next_num:04d}"
                print(f"✅ Next JO: {result}")
            except Exception as e:
                print(f"❌ JO generation failed: {e}")
        else:
            print("❌ job_order column missing")
        
        # Test a simple insert
        print("\n🧪 Testing ticket insertion...")
        try:
            # Get next JO
            job_order = None
            if 'job_order' in col_names:
                cursor.execute(
                    """
                    SELECT
                        MAX(CAST(SUBSTRING(job_order, 5) AS UNSIGNED)) AS max_num
                    FROM entries
                    WHERE job_order IS NOT NULL
                      AND job_order REGEXP '^jo-[0-9]+$'
                    """
                )
                row = cursor.fetchone()
                max_num = row["max_num"] if row else None
                next_num = (int(max_num) if max_num is not None else 0) + 1
                job_order = f"jo-{next_num:04d}"
            
            # Prepare insert data
            insert_cols = ["store_name", "subject", "concern", "status", "date"]
            insert_values = ["%s", "%s", "%s", "%s", "NOW()"]
            insert_params = ["Test Store", "Test Subject", "Test Concern", "pending"]
            
            if job_order and 'job_order' in col_names:
                insert_cols.append("job_order")
                insert_values.append("%s")
                insert_params.append(job_order)
            
            # Execute insert
            sql = f"INSERT INTO entries ({', '.join(insert_cols)}) VALUES ({', '.join(insert_values)})"
            print(f"SQL: {sql}")
            print(f"Params: {insert_params}")
            
            cursor.execute(sql, insert_params)
            ticket_id = cursor.lastrowid
            print(f"✅ Test ticket created with ID: {ticket_id}")
            
            # Clean up - delete the test ticket
            cursor.execute("DELETE FROM entries WHERE ticket_no = %s", (ticket_id,))
            print("🧹 Test ticket cleaned up")
            
        except Exception as e:
            print(f"❌ Ticket insertion failed: {e}")
            import traceback
            traceback.print_exc()
        
        db.commit()
        cursor.close()
        db.close()
        
        print("\n🎉 Database test completed!")
        return True
        
    except Exception as e:
        print(f"❌ Database test failed: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = test_database()
    exit(0 if success else 1)
