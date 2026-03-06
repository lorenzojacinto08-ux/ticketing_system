#!/usr/bin/env python3
"""
Test script to test add_ticket functionality with authentication
"""

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app import app
from flask import session

def test_add_ticket_with_auth():
    """Test adding a ticket with simulated authentication"""
    
    print("🧪 Testing add_ticket with authentication...")
    
    with app.test_client() as client:
        with client.session_transaction() as sess:
            # Simulate a logged-in user
            sess['user_id'] = 1
            sess['user_role'] = 'admin'
            sess['email'] = 'test@example.com'
        
        # Test GET request to add-ticket page
        response = client.get('/add-ticket')
        print(f"GET /add-ticket status: {response.status_code}")
        
        if response.status_code == 200:
            print("✅ Add ticket page accessible with auth")
            # Check if next_jo is in the response
            if 'jo-' in response.get_data(as_text=True):
                print("✅ JO number pre-filled in form")
        else:
            print(f"❌ Unexpected status: {response.status_code}")
        
        # Test POST request (simulate form submission)
        form_data = {
            'name': 'Test Store Auth',
            'subject': 'Test Subject Auth',
            'reported_concern': 'Test Concern Auth - This is a detailed description of the issue that needs to be resolved',
            'contact_number': '0987654321',
            'email': 'auth@test.com',
            'status': 'pending',
            'assigned_to': 'Jake'
        }
        
        response = client.post('/add-ticket', data=form_data, follow_redirects=False)
        
        print(f"POST /add-ticket status: {response.status_code}")
        
        if response.status_code == 302:
            print("✅ Redirected after submission")
            location = response.location
            print(f"Redirected to: {location}")
            
            # Follow the redirect to see if we get to home page
            response = client.get(location, follow_redirects=True)
            print(f"Follow redirect status: {response.status_code}")
            
            # Check for success message
            if 'Ticket added successfully' in response.get_data(as_text=True):
                print("✅ Success message found")
            else:
                print("❌ Success message not found")
                # Look for any error messages
                response_text = response.get_data(as_text=True)
                if 'alert-danger' in response_text or 'error' in response_text.lower():
                    print("❌ Error message found in response")
                    # Extract error message
                    import re
                    error_match = re.search(r'alert-danger[^>]*>([^<]+)', response_text)
                    if error_match:
                        print(f"Error: {error_match.group(1).strip()}")
                        
        elif response.status_code == 200:
            print("Form returned with validation errors")
            response_text = response.get_data(as_text=True)
            
            # Look for validation errors
            if 'Please fill in all required fields' in response_text:
                print("❌ Validation error: Required fields missing")
            elif 'alert-danger' in response_text:
                print("❌ Other error in form")
                # Extract error message
                import re
                error_match = re.search(r'alert-danger[^>]*>([^<]+)', response_text)
                if error_match:
                    print(f"Error: {error_match.group(1).strip()}")
        else:
            print(f"❌ Unexpected status: {response.status_code}")
            print(response.text[:500])

def test_edge_cases():
    """Test edge cases that might cause 500 errors"""
    
    print("\n🔍 Testing edge cases...")
    
    with app.test_client() as client:
        with client.session_transaction() as sess:
            sess['user_id'] = 1
            sess['user_role'] = 'admin'
        
        # Test 1: Missing required fields
        print("\n1. Testing missing required fields...")
        response = client.post('/add-ticket', data={
            'name': '',
            'subject': '',
            'reported_concern': '',
            'contact_number': '',
            'email': ''
        })
        print(f"Status: {response.status_code}")
        
        # Test 2: Very long input
        print("\n2. Testing very long input...")
        long_text = "A" * 10000  # 10k characters
        response = client.post('/add-ticket', data={
            'name': 'Test Store',
            'subject': 'Test Subject',
            'reported_concern': long_text,
            'contact_number': '1234567890',
            'email': 'test@example.com'
        })
        print(f"Status: {response.status_code}")
        
        # Test 3: Special characters
        print("\n3. Testing special characters...")
        response = client.post('/add-ticket', data={
            'name': 'Test Store & Co.',
            'subject': 'Test <script>alert("xss")</script>',
            'reported_concern': 'Issue with quotes: "test" and apostrophes: \'test\'',
            'contact_number': '123-456-7890',
            'email': 'test+special@example.com'
        })
        print(f"Status: {response.status_code}")

if __name__ == "__main__":
    print("🚀 Starting authenticated add_ticket tests...\n")
    
    test_add_ticket_with_auth()
    test_edge_cases()
    
    print("\n🎉 Tests completed!")
