#!/usr/bin/env python3
"""
Test script to simulate adding a ticket via POST request
"""

import requests
from urllib.parse import urljoin

def test_add_ticket(base_url="https://your-app-name.railway.app"):
    """Test the add_ticket endpoint"""
    
    # First, let's try to access the home page to see if we're redirected to login
    session = requests.Session()
    
    print("🔍 Testing add ticket functionality...")
    
    # Try to access home page (should redirect to login)
    try:
        response = session.get(f"{base_url}/")
        print(f"Home page status: {response.status_code}")
        if response.status_code == 302:
            print("Redirected to login as expected")
        elif response.status_code == 200:
            print("Already logged in or no auth required")
        else:
            print(f"Unexpected status: {response.status_code}")
            print(f"Response: {response.text[:500]}")
    except Exception as e:
        print(f"Error accessing home page: {e}")
        return False
    
    # Try to access add-ticket page
    try:
        response = session.get(f"{base_url}/add-ticket")
        print(f"Add ticket page status: {response.status_code}")
        if response.status_code == 200:
            print("Add ticket page accessible")
        elif response.status_code == 302:
            print("Redirected from add-ticket (likely need login)")
        else:
            print(f"Unexpected status: {response.status_code}")
    except Exception as e:
        print(f"Error accessing add-ticket page: {e}")
    
    # Test health endpoint
    try:
        response = requests.get(f"{base_url}/health")
        print(f"Health check status: {response.status_code}")
        if response.status_code == 200:
            print(f"Health check response: {response.json()}")
        else:
            print(f"Health check failed: {response.text}")
    except Exception as e:
        print(f"Error with health check: {e}")
    
    return True

if __name__ == "__main__":
    test_add_ticket()
