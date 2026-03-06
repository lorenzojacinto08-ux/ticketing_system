#!/usr/bin/env python3
"""
Test script to test add_ticket functionality locally
"""

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app import app, get_db_connection, compute_next_job_order
import mysql.connector

def test_add_ticket_directly():
    """Test adding a ticket directly using the app's functions"""
    
    print("🧪 Testing direct ticket insertion...")
    
    try:
        # Get database connection
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        
        # Get table columns
        cursor.execute("SHOW COLUMNS FROM entries")
        cols = {row['Field'] for row in cursor.fetchall()}
        print(f"✅ Available columns: {sorted(cols)}")
        
        # Test JO generation
        jo_col = "job_order" if "job_order" in cols else ("remedy" if "remedy" in cols else None)
        if jo_col:
            next_jo = compute_next_job_order(cursor, jo_col)
            print(f"✅ Next JO: {next_jo}")
        
        # Test ticket insertion (simulate form data)
        name = "Test Store Direct"
        subject = "Test Subject Direct"
        reported_concern = "Test Concern Direct"
        contact_number = "1234567890"
        email = "test@example.com"
        status = "pending"
        
        # Build insert data like the app does
        insert_cols = []
        insert_sql_values = []
        insert_params = []

        def add_param_col(col_name, value):
            insert_cols.append(col_name)
            insert_sql_values.append("%s")
            insert_params.append(value)

        def add_sql_col(col_name, sql_expr):
            insert_cols.append(col_name)
            insert_sql_values.append(sql_expr)

        if "store_name" in cols:
            add_param_col("store_name", name)
        if "contact_number" in cols:
            add_param_col("contact_number", contact_number)
        if "email" in cols:
            add_param_col("email", email)
        if "subject" in cols:
            add_param_col("subject", subject)
        if jo_col and next_jo:
            add_param_col(jo_col, next_jo)

        concern_col = next(
            (c for c in ("reported_concern", "reportedConcern", "concern", "details", "description") if c in cols),
            None,
        )
        print(f"📝 Using concern column: {concern_col}")
        if concern_col:
            add_param_col(concern_col, reported_concern)

        if "status" in cols:
            add_param_col("status", status)

        if "date" in cols:
            add_sql_col("date", "NOW()")
        elif "created_at" in cols:
            add_sql_col("created_at", "NOW()")

        if not insert_cols:
            print("❌ No matching columns found for insert")
            return False

        sql = f"INSERT INTO entries ({', '.join(insert_cols)}) VALUES ({', '.join(insert_sql_values)})"
        print(f"🔍 SQL: {sql}")
        print(f"📋 Params: {insert_params}")
        
        # Execute the insertion
        cursor.execute(sql, insert_params)
        ticket_pk = cursor.lastrowid
        print(f"✅ Ticket created with ID: {ticket_pk}")
        
        # Clean up - delete the test ticket
        cursor.execute("DELETE FROM entries WHERE ticket_no = %s", (ticket_pk,))
        print("🧹 Test ticket cleaned up")
        
        db.commit()
        cursor.close()
        db.close()
        
        return True
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_flask_app():
    """Test the Flask app directly"""
    
    print("\n🌐 Testing Flask app context...")
    
    with app.test_client() as client:
        # Test GET request to add-ticket page
        response = client.get('/add-ticket')
        print(f"GET /add-ticket status: {response.status_code}")
        
        if response.status_code == 302:
            print("Redirected (likely to login)")
        elif response.status_code == 200:
            print("✅ Add ticket page accessible")
        else:
            print(f"❌ Unexpected status: {response.status_code}")
            print(response.text[:500])
        
        # Test POST request (simulate form submission)
        response = client.post('/add-ticket', data={
            'name': 'Test Store Flask',
            'subject': 'Test Subject Flask',
            'reported_concern': 'Test Concern Flask',
            'contact_number': '0987654321',
            'email': 'flask@test.com',
            'status': 'pending'
        }, follow_redirects=False)
        
        print(f"POST /add-ticket status: {response.status_code}")
        
        if response.status_code == 302:
            print("✅ Redirected after successful submission")
            location = response.location
            print(f"Redirected to: {location}")
        elif response.status_code == 200:
            print("Form returned with errors (check validation)")
            print(response.text[:500])
        else:
            print(f"❌ Unexpected status: {response.status_code}")
            print(response.text[:500])

if __name__ == "__main__":
    print("🚀 Starting local add_ticket tests...\n")
    
    # Test direct database insertion
    success1 = test_add_ticket_directly()
    
    # Test Flask app
    test_flask_app()
    
    print(f"\n🎉 Tests completed! Direct insertion: {'✅' if success1 else '❌'}")
