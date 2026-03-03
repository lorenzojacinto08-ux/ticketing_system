#!/usr/bin/env python3
"""
Development server with ngrok for shareable URL
"""

import os
import sys
import time
import threading
from pyngrok import ngrok, conf

def start_ngrok():
    """Start ngrok tunnel"""
    # Get ngrok auth token from environment if set
    if os.getenv("NGROK_AUTH_TOKEN"):
        conf.get_default().auth_token = os.getenv("NGROK_AUTH_TOKEN")
    
    # Start ngrok tunnel
    public_url = ngrok.connect(5000).public_url
    print(f"🚀 Public URL: {public_url}")
    print(f"🌐 Local URL: http://localhost:5000")
    print("📝 Share the public URL for testing!")
    
    return public_url

def main():
    """Main development server"""
    print("🔧 Starting Flask development server with ngrok...")
    
    # Start ngrok in a separate thread
    ngrok_thread = threading.Thread(target=start_ngrok)
    ngrok_thread.daemon = True
    ngrok_thread.start()
    
    # Give ngrok time to start
    time.sleep(2)
    
    # Import and run Flask app
    from app import app
    app.run(
        host="0.0.0.0",
        port=5000,
        debug=True
    )

if __name__ == "__main__":
    main()
