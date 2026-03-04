#!/usr/bin/env python3
"""
Script to import local database to Railway MySQL
"""
import mysql.connector
import os
from mysql.connector import Error

def import_to_railway():
    # Railway connection details
    config = {
        'host': 'caboose.proxy.rlwy.net',
        'port': 51406,
        'user': 'root',
        'password': 'lTUapGaKJUYSHtvUaHmUpEYUltXmevXC',
        'database': 'railway'
    }
    
    try:
        # Test connection
        print("Connecting to Railway MySQL...")
        connection = mysql.connector.connect(**config)
        
        if connection.is_connected():
            print("Successfully connected to Railway MySQL")
            
            # Read and execute SQL file
            with open('current_schema.sql', 'r') as file:
                sql_script = file.read()
            
            cursor = connection.cursor()
            
            # Split SQL script into individual statements
            statements = [stmt.strip() for stmt in sql_script.split(';') if stmt.strip()]
            
            print("Importing database schema and data...")
            for statement in statements:
                if statement and not statement.startswith('--'):
                    try:
                        cursor.execute(statement)
                        connection.commit()
                    except Error as e:
                        print(f"Warning: {e}")
            
            print("Database import completed successfully!")
            
            cursor.close()
            connection.close()
            
    except Error as e:
        print(f"Error connecting to Railway MySQL: {e}")
        print("\nPossible solutions:")
        print("1. Check if Railway MySQL service is running")
        print("2. Verify the external host from Railway dashboard")
        print("3. Ensure the password is correct")

if __name__ == "__main__":
    import_to_railway()
