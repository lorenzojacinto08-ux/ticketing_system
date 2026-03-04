#!/usr/bin/env python3
"""
Quick test to verify database data in Railway
"""
import mysql.connector

def test_railway_data():
    config = {
        'host': 'caboose.proxy.rlwy.net',
        'port': 51406,
        'user': 'root',
        'password': 'lTUapGaKJUYSHtvUaHmUpEYUltXmevXC',
        'database': 'railway'
    }
    
    try:
        connection = mysql.connector.connect(**config)
        cursor = connection.cursor(dictionary=True)
        
        # Check entries table
        cursor.execute("SELECT COUNT(*) as count FROM entries")
        result = cursor.fetchone()
        print(f"📊 Total entries in database: {result['count']}")
        
        # Show first 5 entries
        cursor.execute("SELECT ticket_no, store_name, subject, status FROM entries LIMIT 5")
        entries = cursor.fetchall()
        print("\n📋 First 5 entries:")
        for entry in entries:
            print(f"  #{entry['ticket_no']}: {entry['store_name']} - {entry['subject']} ({entry['status']})")
        
        cursor.close()
        connection.close()
        
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    test_railway_data()
