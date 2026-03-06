#!/usr/bin/env python3
"""
Simple script to run the Flask app locally for testing
"""

import os
import sys
from app import app

if __name__ == "__main__":
    print("🚀 Starting Flask app locally...")
    print("📝 You can test the add_ticket functionality at: http://localhost:5000/add-ticket")
    print("🔐 You'll need to log in first. Use existing credentials or create a new user.")
    print("\n📋 Test credentials (if they exist):")
    print("   - Email: test2@gmail.com")
    print("   - Email: super_admin@gmail.com")
    print("\n⚠️  Press Ctrl+C to stop the server")
    
    # Run the app
    app.run(host='0.0.0.0', port=5000, debug=True)
