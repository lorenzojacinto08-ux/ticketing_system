#!/usr/bin/env python3
"""
Railway deployment script to ensure database is properly configured
"""

import os
import sys
from app import get_db_connection, run_migrations

def setup_railway_database():
    """Setup database for Railway deployment"""
    print("🚀 Setting up Railway database...")
    
    try:
        # Test database connection
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        print("✅ Database connection successful")
        
        # Run migrations to ensure all columns exist
        print("🔧 Running database migrations...")
        run_migrations()
        print("✅ Database migrations completed")
        
        # Verify job_order column exists and is working
        cursor.execute("SHOW COLUMNS FROM entries LIKE 'job_order'")
        job_order_exists = cursor.fetchone()
        
        if job_order_exists:
            print("✅ job_order column exists")
            
            # Test JO generation
            from app import compute_next_job_order
            try:
                next_jo = compute_next_job_order(cursor, "job_order")
                print(f"✅ JO generation working: next JO will be {next_jo}")
            except Exception as e:
                print(f"❌ JO generation test failed: {e}")
        else:
            print("❌ job_order column missing")
        
        # Check company_history table
        cursor.execute("SHOW TABLES LIKE 'company_history'")
        company_history_exists = cursor.fetchone()
        
        if company_history_exists:
            print("✅ company_history table exists")
        else:
            print("⚠️ company_history table missing (will be created by migrations)")
        
        cursor.close()
        db.close()
        
        print("🎉 Railway database setup complete!")
        return True
        
    except Exception as e:
        print(f"❌ Railway database setup failed: {e}")
        return False

if __name__ == "__main__":
    success = setup_railway_database()
    sys.exit(0 if success else 1)
