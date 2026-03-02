from werkzeug.security import generate_password_hash
import mysql.connector

# Reset super admin password to admin123
password_hash = 'scrypt:32768:8:1$WF0JlgZWceviOlJL$c2a62706bdbb2e08ffe2aa519e64850236d65d8fbc2b657261979e759d1bd9a03d0e97aee8e17e673ec7ed11e748b331a73b33096282c4e51f154162fb27be31'

try:
    db = mysql.connector.connect(
        host='localhost',
        database='ticketing_db',
        user='root',
        password=''
    )
    cursor = db.cursor()
    cursor.execute('UPDATE users SET password_hash = %s WHERE email = %s', 
                  (password_hash, 'super_admin@gmail.com'))
    db.commit()
    print('✅ Password reset successfully!')
    print('📧 Email: super_admin@gmail.com')
    print('🔑 Password: admin123')
except Exception as e:
    print(f'❌ Error: {e}')
finally:
    if 'db' in locals() and db.is_connected():
        db.close()
