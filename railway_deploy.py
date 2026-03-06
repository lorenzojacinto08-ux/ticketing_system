#!/usr/bin/env python3
"""
Railway deployment script to ensure database is properly configured
"""

import os
import sys
import mysql.connector
from urllib.parse import urlparse

def get_db_connection():
    """Get database connection using Railway environment variables"""
    # Try Railway's DATABASE_URL first, then fall back to individual variables
    database_url = os.getenv("DATABASE_URL")
    
    print(f"DEBUG: DATABASE_URL present: {'Yes' if database_url else 'No'}")
    
    if database_url:
        try:
            # Parse DATABASE_URL format: mysql://username:password@host:port/database
            parsed = urlparse(database_url)
            print(f"DEBUG: Parsed DB - Host: {parsed.hostname}, DB: {parsed.path[1:] if parsed.path else 'None'}")
            
            return mysql.connector.connect(
                host=parsed.hostname,
                user=parsed.username,
                password=parsed.password,
                database=parsed.path[1:],  # Remove leading slash
                port=parsed.port or 3306,
                autocommit=False
            )
        except Exception as e:
            print(f"ERROR: Failed to connect using DATABASE_URL: {e}")
            raise
    
    # Fall back to individual environment variables
    print(f"DEBUG: Using individual DB variables - Host: {os.getenv('DB_HOST')}, DB: {os.getenv('DB_NAME')}")
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "localhost"),
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASSWORD", "root"),
        database=os.getenv("DB_NAME", "ticketing_db"),
        port=int(os.getenv("DB_PORT", "3306")),
        autocommit=False
    )

def run_migrations():
    """Run database migrations to ensure schema is up to date"""
    try:
        db = get_db_connection()
        cursor = db.cursor()
        
        print("🔧 Running database migrations...")
        
        # Check if job_order column exists (critical for JO generation)
        cursor.execute("SHOW COLUMNS FROM entries LIKE 'job_order'")
        if not cursor.fetchone():
            print("Adding job_order column...")
            cursor.execute("ALTER TABLE entries ADD COLUMN job_order VARCHAR(10) DEFAULT NULL AFTER remedy")
            print("✅ Added job_order column")
        else:
            print("✅ job_order column already exists")
        
        # Check if job_order UNIQUE constraint exists
        cursor.execute("""
            SELECT INDEX_NAME FROM information_schema.STATISTICS 
            WHERE TABLE_SCHEMA = DATABASE() 
            AND TABLE_NAME = 'entries' 
            AND INDEX_NAME = 'job_order_UNIQUE'
        """)
        if not cursor.fetchone():
            print("Adding job_order UNIQUE constraint...")
            cursor.execute("ALTER TABLE entries ADD UNIQUE INDEX job_order_UNIQUE (job_order)")
            print("✅ Added job_order UNIQUE constraint")
        else:
            print("✅ job_order UNIQUE constraint already exists")
        
        # Check if service_done column exists
        cursor.execute("SHOW COLUMNS FROM entries LIKE 'service_done'")
        if not cursor.fetchone():
            print("Adding service_done column...")
            cursor.execute("ALTER TABLE entries ADD COLUMN service_done TEXT DEFAULT NULL AFTER job_order")
            print("✅ Added service_done column")
        else:
            print("✅ service_done column already exists")
        
        # Check if labor_fee column exists
        cursor.execute("SHOW COLUMNS FROM entries LIKE 'labor_fee'")
        if not cursor.fetchone():
            print("Adding labor_fee column...")
            cursor.execute("ALTER TABLE entries ADD COLUMN labor_fee DECIMAL(10, 2) DEFAULT NULL AFTER service_done")
            print("✅ Added labor_fee column")
        else:
            print("✅ labor_fee column already exists")
        
        # Check if company_history table exists
        cursor.execute("SHOW TABLES LIKE 'company_history'")
        if not cursor.fetchone():
            print("Creating company_history table...")
            cursor.execute("""
                CREATE TABLE `company_history` (
                  `id` int NOT NULL AUTO_INCREMENT,
                  `company_name` varchar(100) NOT NULL,
                  `usage_count` int NOT NULL DEFAULT 1,
                  `last_used` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                  PRIMARY KEY (`id`),
                  UNIQUE KEY `unique_company_name` (`company_name`),
                  KEY `idx_company_name` (`company_name`),
                  KEY `idx_usage_count` (`usage_count`),
                  KEY `idx_last_used` (`last_used`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
            """)
            print("✅ Added company_history table")
            
            # Populate the table with existing company names from the entries table
            print("Populating company_history table...")
            cursor.execute("""
                INSERT IGNORE INTO `company_history` (company_name, usage_count, last_used)
                SELECT 
                    store_name as company_name,
                    COUNT(*) as usage_count,
                    MAX(date) as last_used
                FROM entries 
                WHERE store_name IS NOT NULL AND store_name != ''
                GROUP BY store_name
                ORDER BY usage_count DESC, last_used DESC
            """)
            print("✅ Populated company_history table with existing data")
        else:
            print("✅ company_history table already exists")
        
        db.commit()
        cursor.close()
        db.close()
        print("✅ All migrations completed successfully")
    except Exception as e:
        print(f"❌ Migration error: {e}")
        raise

def test_ticket_creation():
    """Test creating a ticket to verify everything works"""
    try:
        print("🧪 Testing ticket creation...")
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        
        # Get table structure
        cursor.execute("SHOW COLUMNS FROM entries")
        columns = [row['Field'] for row in cursor.fetchall()]
        print(f"✅ Entries table columns: {columns}")
        
        # Test JO generation
        if 'job_order' in columns:
            cursor.execute(
                """
                SELECT MAX(CAST(SUBSTRING(job_order, 5) AS UNSIGNED)) AS max_num
                FROM entries
                WHERE job_order IS NOT NULL AND job_order REGEXP '^jo-[0-9]+$'
                """
            )
            row = cursor.fetchone()
            max_num = row['max_num'] if row else None
            next_num = (int(max_num) if max_num is not None else 0) + 1
            next_jo = f"jo-{next_num:04d}"
            print(f"✅ JO generation working: next JO will be {next_jo}")
        else:
            print("❌ job_order column missing")
            return False
        
        # Test insert
        insert_cols = ["store_name", "subject", "concern", "status", "date"]
        insert_values = ["%s", "%s", "%s", "%s", "NOW()"]
        insert_params = ["Railway Test", "Test Subject", "Test Concern", "pending"]
        
        if 'job_order' in columns:
            insert_cols.append("job_order")
            insert_values.append("%s")
            insert_params.append(next_jo)
        
        sql = f"INSERT INTO entries ({', '.join(insert_cols)}) VALUES ({', '.join(insert_values)})"
        cursor.execute(sql, insert_params)
        ticket_id = cursor.lastrowid
        print(f"✅ Test ticket created with ID: {ticket_id}")
        
        # Clean up
        cursor.execute("DELETE FROM entries WHERE ticket_no = %s", (ticket_id,))
        print("🧹 Test ticket cleaned up")
        
        db.commit()
        cursor.close()
        db.close()
        return True
        
    except Exception as e:
        print(f"❌ Ticket creation test failed: {e}")
        import traceback
        traceback.print_exc()
        return False

def setup_railway_database():
    """Setup database for Railway deployment"""
    print("🚀 Setting up Railway database...")
    
    try:
        # Test database connection
        print("🔗 Testing database connection...")
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        print("✅ Database connection successful")
        
        # Check if entries table exists
        cursor.execute("SHOW TABLES LIKE 'entries'")
        if not cursor.fetchone():
            print("❌ entries table does not exist!")
            return False
        
        cursor.close()
        db.close()
        
        # Run migrations
        run_migrations()
        
        # Test ticket creation
        if test_ticket_creation():
            print("🎉 Railway database setup complete and tested!")
            return True
        else:
            print("❌ Railway database setup failed during testing")
            return False
        
    except Exception as e:
        print(f"❌ Railway database setup failed: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = setup_railway_database()
    sys.exit(0 if success else 1)
