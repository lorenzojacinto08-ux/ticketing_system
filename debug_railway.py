#!/usr/bin/env python3
"""
Debug script to test Railway database connection and ticket creation
"""

import os
import sys
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Import app functions
sys.path.append(os.path.dirname(__file__))
from app import get_db_connection, run_migrations, compute_next_job_order

def test_database():
    """Test database connection and schema"""
    print("🔍 Testing Railway database connection...")
    
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
                next_jo = compute_next_job_order(cursor, "job_order")
                print(f"✅ Next JO: {next_jo}")
            except Exception as e:
                print(f"❌ JO generation failed: {e}")
        else:
            print("❌ job_order column missing")
        
        # Test a simple insert
        print("\n🧪 Testing ticket insertion...")
        try:
            # Get next JO
            jo_col = "job_order" if "job_order" in col_names else ("remedy" if "remedy" in col_names else None)
            job_order = compute_next_job_order(cursor, jo_col) if jo_col else None
            
            # Prepare insert data
            insert_cols = []
            insert_values = []
            insert_params = []
            
            def add_field(col_name, value):
                insert_cols.append(col_name)
                insert_values.append("%s")
                insert_params.append(value)
            
            # Add required fields
            add_field("store_name", "Test Store")
            add_field("subject", "Test Subject") 
            add_field("concern", "Test Concern")
            
            if jo_col and job_order:
                add_field(jo_col, job_order)
            
            add_field("status", "pending")
            insert_cols.append("date")
            insert_values.append("NOW()")
            
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
    sys.exit(0 if success else 1)
