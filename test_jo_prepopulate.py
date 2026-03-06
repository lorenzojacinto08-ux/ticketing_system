#!/usr/bin/env python3
"""
Test script to verify JO number pre-population in add-ticket form
"""

from app import app

def test_jo_prepopulation():
    """Test if JO number is pre-populated in the add-ticket form"""
    
    print("🧪 Testing JO number pre-population...")
    
    with app.test_client() as client:
        with client.session_transaction() as sess:
            # Simulate a logged-in user
            sess['user_id'] = 1
            sess['user_role'] = 'admin'
        
        # Test GET request to add-ticket page
        response = client.get('/add-ticket')
        print(f'GET /add-ticket status: {response.status_code}')
        
        if response.status_code == 200:
            response_text = response.get_data(as_text=True)
            
            # Check if JO number is present in the form
            if 'jo-' in response_text and 'value="jo-' in response_text:
                print('✅ SUCCESS: JO number is pre-populated in the form')
                
                # Extract the JO number
                import re
                jo_match = re.search(r'value="(jo-\d{4})"', response_text)
                if jo_match:
                    print(f'📝 Pre-populated JO: {jo_match.group(1)}')
                else:
                    print('⚠️  JO pattern found but could not extract specific number')
            else:
                print('❌ FAILED: JO number not found in form')
                print('📋 Checking for job_order field...')
                if 'job_order' in response_text:
                    print('✅ job_order field exists')
                else:
                    print('❌ job_order field missing')
                    
                # Show part of the form for debugging
                lines = response_text.split('\n')
                for i, line in enumerate(lines):
                    if 'job_order' in line:
                        print(f'Line {i+1}: {line.strip()}')
                        break
        else:
            print(f'❌ FAILED: Unexpected status {response.status_code}')

if __name__ == "__main__":
    test_jo_prepopulation()
