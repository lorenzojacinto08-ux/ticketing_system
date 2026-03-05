#!/usr/bin/env python3
"""
Test script to trigger log_event calls
"""

import os
import sys

# Add the project directory to Python path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

try:
    from app import app, log_event
    print("🧪 Testing log_event function...")
    
    # Test different log events
    log_event("test_log_event", test="basic_log")
    log_event("user_login", email="test@example.com", role="admin")
    log_event("ticket_created", ticket_no=999, store_name="Test Store")
    
    print("✅ Test log events sent to log_event function")
    print("📝 Check your Railway app_logs table for new entries")
    
except ImportError as e:
    print(f"❌ Cannot import app module: {e}")
    sys.exit(1)
