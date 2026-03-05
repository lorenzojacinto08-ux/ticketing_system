#!/usr/bin/env python3
"""
Test script to verify job order update functionality
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app import get_db_connection

def test_job_order_update():
    """Test that job order updates are properly saved and retrieved"""
    
    print("Testing job order update functionality...")
    
    try:
        # Connect to database
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        
        # Get a sample ticket to test with
        cursor.execute("SELECT ticket_no, job_order FROM entries LIMIT 1")
        ticket = cursor.fetchone()
        
        if not ticket:
            print("No tickets found in database")
            return False
            
        ticket_id = ticket['ticket_no']
        original_jo = ticket['job_order']
        
        print(f"Testing with ticket #{ticket_id}, current JO: {original_jo}")
        
        # Test updating the job order
        new_jo = "test-999"
        cursor.execute("UPDATE entries SET job_order = %s WHERE ticket_no = %s", (new_jo, ticket_id))
        db.commit()
        
        # Verify the update
        cursor.execute("SELECT job_order FROM entries WHERE ticket_no = %s", (ticket_id,))
        updated_ticket = cursor.fetchone()
        
        if updated_ticket['job_order'] == new_jo:
            print(f"✓ Job order successfully updated to: {new_jo}")
        else:
            print(f"✗ Job order update failed. Expected: {new_jo}, Got: {updated_ticket['job_order']}")
            return False
            
        # Restore original job order
        cursor.execute("UPDATE entries SET job_order = %s WHERE ticket_no = %s", (original_jo, ticket_id))
        db.commit()
        
        print(f"✓ Restored original job order: {original_jo}")
        
        cursor.close()
        db.close()
        
        print("✓ Job order update test passed!")
        return True
        
    except Exception as e:
        print(f"✗ Test failed with error: {e}")
        return False

if __name__ == "__main__":
    success = test_job_order_update()
    sys.exit(0 if success else 1)
